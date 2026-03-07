from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import json
import re
import shlex
import shutil
import subprocess
import sys
import tempfile

import tomlkit


ROOT = Path(__file__).resolve().parents[3]
PACKAGES_FILE = ROOT / "home/.chezmoidata/packages-darwin.toml"


@dataclass(frozen=True)
class DriftItem:
    kind: str
    name: str
    mas_id: int | None = None
    description: str | None = None


@dataclass(frozen=True)
class RemoveResult:
    ok: bool
    message: str | None = None
    blockers: tuple[str, ...] = ()


def _is_not_installed_error(text: str) -> bool:
    lowered = (text or "").lower()
    return "is not installed" in lowered or "no such keg" in lowered


@dataclass
class ArrayRecord:
    name: str
    comment: str | None


def run(cmd: list[str], timeout: float | None = None) -> tuple[int, str, str]:
    return run_with_title(cmd, timeout=timeout, title=None)


def gum_spinner_available() -> bool:
    return shutil.which("gum") is not None and sys.stdin.isatty() and sys.stderr.isatty()


def run_with_title(cmd: list[str], timeout: float | None = None, title: str | None = None) -> tuple[int, str, str]:
    if not title or not gum_spinner_available():
        try:
            proc = subprocess.run(cmd, text=True, capture_output=True, timeout=timeout)
            return proc.returncode, proc.stdout, proc.stderr
        except subprocess.TimeoutExpired:
            return 124, "", "timeout"

    cmd_str = " ".join(shlex.quote(part) for part in cmd)
    with tempfile.TemporaryDirectory(prefix="pkg-reconcile-") as td:
        out_path = str(Path(td) / "stdout.txt")
        err_path = str(Path(td) / "stderr.txt")
        spin_cmd = [
            "gum",
            "spin",
            "--spinner",
            "dot",
            "--title",
            title,
            "--",
            "sh",
            "-c",
            f"{cmd_str} >{shlex.quote(out_path)} 2>{shlex.quote(err_path)}",
        ]
        try:
            proc = subprocess.run(
                spin_cmd,
                text=True,
                stdin=sys.stdin,
                stdout=sys.stdout,
                stderr=sys.stderr,
                timeout=timeout,
            )
            out = Path(out_path).read_text(encoding="utf-8", errors="replace")
            err = Path(err_path).read_text(encoding="utf-8", errors="replace")
            return proc.returncode, out, err
        except subprocess.TimeoutExpired:
            return 124, "", "timeout"


def run_live(
    cmd: list[str],
    title: str | None = None,
    timeout: float | None = None,
    use_spinner: bool = True,
) -> tuple[int, str]:
    if title and use_spinner and gum_spinner_available():
        code, out, err = run_with_title(cmd, timeout=timeout, title=title)
        if code == 0:
            return 0, ""
        reason = (err or out).strip()
        return code, (reason or f"command exited with status {code}")
    elif title:
        print(title)
    try:
        proc = subprocess.run(
            cmd,
            text=True,
            stdin=sys.stdin,
            stdout=sys.stdout,
            stderr=sys.stderr,
            timeout=timeout,
        )
        if proc.returncode == 0:
            return 0, ""
        return proc.returncode, f"command exited with status {proc.returncode}"
    except subprocess.TimeoutExpired:
        return 124, "timeout"


def command_exists(name: str) -> bool:
    return shutil.which(name) is not None


def load_doc():
    try:
        return tomlkit.parse(PACKAGES_FILE.read_text(encoding="utf-8"))
    except Exception as e:
        raise RuntimeError(f"Failed to parse {PACKAGES_FILE}: {e}") from e


def save_doc(doc) -> None:
    rendered = tomlkit.dumps(doc)
    # Guard against emitting invalid TOML.
    tomlkit.parse(rendered)
    PACKAGES_FILE.write_text(rendered, encoding="utf-8")


def get_darwin_tables(doc):
    packages = doc.get("packages")
    if packages is None or "darwin" not in packages:
        raise RuntimeError("Missing [packages.darwin] in packages-darwin.toml")
    return packages["darwin"]


def load_expected() -> tuple[set[str], set[str], set[str], dict[int, str]]:
    doc = load_doc()
    darwin = get_darwin_tables(doc)
    taps = {str(x) for x in darwin.get("taps", [])}
    brews = {str(x) for x in darwin.get("brews", [])}
    casks = {str(x) for x in darwin.get("casks", [])}
    mas: dict[int, str] = {}
    for item in darwin.get("mas", []):
        try:
            mas_id = int(item["id"])
            mas[mas_id] = str(item["name"])
        except Exception:
            continue
    return taps, brews, casks, mas


def installed_taps(show_progress: bool = False) -> set[str]:
    if not command_exists("brew"):
        return set()
    title = "Loading installed Homebrew taps..." if show_progress else None
    code, out, _ = run_with_title(["brew", "tap"], title=title)
    if code != 0:
        return set()
    return {line.strip() for line in out.splitlines() if line.strip()}


def installed_brews(show_progress: bool = False) -> set[str]:
    if not command_exists("brew"):
        return set()
    title = "Loading installed Homebrew formulas (leaves)..." if show_progress else None
    code, out, _ = run_with_title(["brew", "leaves"], title=title)
    if code != 0:
        return set()
    return {line.strip() for line in out.splitlines() if line.strip()}


def installed_casks(show_progress: bool = False) -> set[str]:
    if not command_exists("brew"):
        return set()
    title = "Loading installed Homebrew casks..." if show_progress else None
    code, out, _ = run_with_title(["brew", "list", "--cask"], title=title)
    if code != 0:
        return set()
    return {line.strip() for line in out.splitlines() if line.strip()}


def installed_mas(show_progress: bool = False) -> dict[int, str]:
    if not command_exists("mas"):
        return {}
    title = "Loading installed Mac App Store apps..." if show_progress else None
    code, out, _ = run_with_title(["mas", "list"], title=title)
    if code != 0:
        return {}
    result: dict[int, str] = {}
    for line in out.splitlines():
        entry = line.strip()
        if not entry:
            continue
        first, sep, rest = entry.partition(" ")
        if not sep or not first.isdigit():
            continue
        name = rest.rsplit(" (", 1)[0].strip() if " (" in rest else rest.strip()
        result[int(first)] = name
    return result


def collect_drift(show_progress: bool = False) -> list[DriftItem]:
    expected_taps, expected_brews, expected_casks, expected_mas = load_expected()
    expected_cask_normalized = set().union(*(_cask_equivalents(name) for name in expected_casks))
    result: list[DriftItem] = []

    for tap in sorted(installed_taps(show_progress=show_progress) - expected_taps):
        result.append(DriftItem(kind="tap", name=tap))
    for brew in sorted(installed_brews(show_progress=show_progress) - expected_brews):
        result.append(DriftItem(kind="brew", name=brew))
    for cask in sorted(installed_casks(show_progress=show_progress)):
        if cask in expected_casks:
            continue
        if any(eq in expected_cask_normalized for eq in _cask_equivalents(cask)):
            continue
        result.append(DriftItem(kind="cask", name=cask))
    for mas_id, name in sorted(installed_mas(show_progress=show_progress).items(), key=lambda kv: kv[1].lower()):
        if mas_id not in expected_mas:
            result.append(DriftItem(kind="mas", name=name, mas_id=mas_id, description="Mac App Store app"))
    return result


def _sanitize_comment(text: str | None) -> str | None:
    if not text:
        return None
    cleaned = " ".join(text.replace("\r", " ").replace("\n", " ").split()).strip()
    if not cleaned:
        return None
    return cleaned.replace("#", "")


def _brew_info_json(kind: str, name: str, show_progress: bool = False) -> dict | None:
    if not command_exists("brew"):
        return None
    cmd = ["brew", "info", "--json=v2", name]
    if kind == "cask":
        cmd.insert(2, "--cask")
    title = f"Loading {kind} info: {name}..." if show_progress else None
    code, out, _ = run_with_title(cmd, timeout=8.0, title=title)
    if code != 0 or not out.strip():
        return None
    try:
        return json.loads(out)
    except json.JSONDecodeError:
        return None


def describe_brew_formula(name: str, show_progress: bool = False) -> str | None:
    info = _brew_info_json("brew", name, show_progress=show_progress)
    if not info:
        return None
    formulas = info.get("formulae") or []
    if not formulas:
        return None
    return _sanitize_comment(str(formulas[0].get("desc", "")))


def describe_brew_cask(name: str, show_progress: bool = False) -> str | None:
    info = _brew_info_json("cask", name, show_progress=show_progress)
    if not info:
        return None
    casks = info.get("casks") or []
    if not casks:
        return None
    return _sanitize_comment(str(casks[0].get("desc", "")))


def describe_tap(name: str, show_progress: bool = False) -> str | None:
    if not command_exists("brew"):
        return None
    title = f"Loading tap info: {name}..." if show_progress else None
    code, out, _ = run_with_title(["brew", "tap-info", "--json", name], timeout=8.0, title=title)
    if code != 0 or not out.strip():
        return "Homebrew tap"
    try:
        payload = json.loads(out)
        if isinstance(payload, list) and payload:
            first = payload[0]
            remote = str(first.get("remote") or "").strip()
            formulas = [str(x).split("/")[-1] for x in (first.get("formula_names") or []) if str(x).strip()]
            casks = [str(x).split("/")[-1] for x in (first.get("cask_tokens") or []) if str(x).strip()]

            parts: list[str] = []
            if remote:
                parts.append(remote)

            tokens = formulas + casks
            if tokens:
                preview = ", ".join(tokens[:3])
                more = len(tokens) - 3
                if more > 0:
                    preview = f"{preview}, +{more} more"
                parts.append(f"contains {preview}")

            if parts:
                return _sanitize_comment(f"Homebrew tap: {'; '.join(parts)}")
    except json.JSONDecodeError:
        pass
    return "Homebrew tap"


def gum_choose(item: DriftItem, index: int, total: int) -> str:
    if not sys.stdin.isatty() or not sys.stderr.isatty():
        print("Interactive terminal required for reconcile; skipping item.", file=sys.stderr)
        return "skip"

    header = f"[{index}/{total}] local-only {item.kind}: {item.name}"
    if item.kind == "mas" and item.mas_id is not None:
        header = f"[{index}/{total}] local-only {item.kind}: {item.name} (id {item.mas_id})"
    if item.description:
        header = f"{header}\n{item.description}"
    remove_label = "untap" if item.kind == "tap" else "uninstall"
    proc = subprocess.run(
        [
            "gum",
            "choose",
            "--header",
            header,
            "skip",
            "add to dotfiles",
            remove_label,
            "quit",
        ],
        text=True,
        stdin=sys.stdin,
        stdout=subprocess.PIPE,
        stderr=sys.stderr,
    )
    if proc.returncode != 0:
        return "quit"
    return proc.stdout.strip() or "skip"


def with_description(item: DriftItem) -> DriftItem:
    if item.description:
        return item
    if item.kind == "brew":
        return DriftItem(
            kind=item.kind,
            name=item.name,
            mas_id=item.mas_id,
            description=describe_brew_formula(item.name, show_progress=True),
        )
    if item.kind == "cask":
        return DriftItem(
            kind=item.kind,
            name=item.name,
            mas_id=item.mas_id,
            description=describe_brew_cask(item.name, show_progress=True),
        )
    if item.kind == "tap":
        return DriftItem(
            kind=item.kind,
            name=item.name,
            mas_id=item.mas_id,
            description=describe_tap(item.name, show_progress=True),
        )
    return item


def gum_confirm(prompt: str) -> bool:
    if not sys.stdin.isatty() or not sys.stderr.isatty():
        return False
    proc = subprocess.run(
        ["gum", "confirm", prompt],
        text=True,
        stdin=sys.stdin,
        stdout=sys.stdout,
        stderr=sys.stderr,
    )
    return proc.returncode == 0


def append_unique_array(darwin, key: str, new_item: str, description: str | None = None) -> bool:
    arr = darwin.get(key)
    if arr is None:
        arr = tomlkit.array()
        arr.multiline(True)
        darwin[key] = arr

    current = {str(v) for v in arr}
    if new_item in current:
        return False
    comment = _sanitize_comment(description)
    item = tomlkit.item(new_item)
    if comment:
        item.comment(comment)
    arr.append(item)
    return True


def insert_array_entry_with_comment(key: str, new_item: str, description: str | None = None) -> bool:
    text = PACKAGES_FILE.read_text(encoding="utf-8")
    lines = text.splitlines(keepends=True)

    # Fast duplicate check using existing parser-backed expectation sets.
    expected_taps, expected_brews, expected_casks, _ = load_expected()
    if key == "taps" and new_item in expected_taps:
        return False
    if key == "brews" and new_item in expected_brews:
        return False
    if key == "casks" and new_item in expected_casks:
        return False

    start_re = re.compile(rf"^\s*{re.escape(key)}\s*=\s*\[\s*$")
    start_idx = -1
    for i, line in enumerate(lines):
        if start_re.match(line):
            start_idx = i
            break
    if start_idx < 0:
        return False

    end_idx = -1
    for i in range(start_idx + 1, len(lines)):
        if lines[i].strip() == "]":
            end_idx = i
            break
    if end_idx < 0:
        return False

    indent = "    "
    comment = _sanitize_comment(description)
    insert_lines: list[str] = []
    if comment:
        insert_lines.append(f"{indent}# {comment}\n")
    insert_lines.append(f'{indent}"{new_item}",\n')

    new_lines = lines[:end_idx] + insert_lines + lines[end_idx:]
    PACKAGES_FILE.write_text("".join(new_lines), encoding="utf-8")
    return True


def append_unique_mas(darwin, mas_id: int, name: str) -> bool:
    current = darwin.get("mas")
    if current is None:
        current = tomlkit.aot()
        darwin["mas"] = current

    for entry in current:
        try:
            if int(entry["id"]) == mas_id:
                return False
        except Exception:
            continue

    t = tomlkit.table()
    t["name"] = name
    t["id"] = mas_id
    current.append(t)
    return True


def _normalize_cask_token(token: str) -> str:
    # Treat common alias forms (e.g. 1password-beta vs 1password@beta) as equivalent.
    return re.sub(r"[^a-z0-9]+", "", token.lower())


def _cask_equivalents(token: str) -> set[str]:
    norm = _normalize_cask_token(token)
    eq = {norm}
    if norm.endswith("app") and len(norm) > 3:
        eq.add(norm[:-3])
    else:
        eq.add(norm + "app")
    return eq


def resolve_cask_alias(token: str) -> str | None:
    try:
        _, _, expected_casks, _ = load_expected()
    except Exception:
        return None
    normalized = _cask_equivalents(token)
    matches = [candidate for candidate in expected_casks if _cask_equivalents(candidate) & normalized]
    if len(matches) == 1:
        return matches[0]
    return None


def set_sorted_mas(darwin, mas_id: int, name: str) -> bool:
    """Backwards-compatible alias kept for call sites."""
    return append_unique_mas(darwin, mas_id, name)


def set_sorted_array(darwin, key: str, new_item: str) -> bool:
    """Backwards-compatible alias kept for call sites."""
    return append_unique_array(darwin, key, new_item)


def add_to_dotfiles(item: DriftItem) -> bool:
    if item.kind == "tap":
        desc = item.description or describe_tap(item.name, show_progress=True)
        return insert_array_entry_with_comment("taps", item.name, desc)
    if item.kind == "brew":
        desc = item.description or describe_brew_formula(item.name, show_progress=True)
        return insert_array_entry_with_comment("brews", item.name, desc)
    if item.kind == "cask":
        desc = item.description or describe_brew_cask(item.name, show_progress=True)
        return insert_array_entry_with_comment("casks", item.name, desc)
    if item.kind == "mas" and item.mas_id is not None:
        doc = load_doc()
        darwin = get_darwin_tables(doc)
        changed = append_unique_mas(darwin, item.mas_id, item.name)
        if changed:
            save_doc(doc)
        return changed
    return False


def parse_untap_blockers(stderr: str) -> tuple[str, ...]:
    marker = "contains the following installed formulae or casks:"
    if marker not in stderr:
        return ()
    lines = [line.strip() for line in stderr.splitlines()]
    try:
        idx = next(i for i, line in enumerate(lines) if marker in line)
    except StopIteration:
        return ()
    blockers: list[str] = []
    for line in lines[idx + 1 :]:
        if not line:
            continue
        if line.lower().startswith("error:"):
            continue
        if " " in line:
            break
        blockers.append(line)
    return tuple(blockers)


def uninstall_blocker(name: str, tap_name: str | None = None) -> tuple[bool, str]:
    context = f" for tap {tap_name}" if tap_name else ""
    code, err = run_live(
        ["brew", "uninstall", name],
        title=f"Running: brew uninstall {name}{context}",
        timeout=180.0,
    )
    if code == 0:
        return True, ""
    code, err2 = run_live(
        ["brew", "uninstall", "--cask", name],
        title=f"Running: brew uninstall --cask {name}{context}",
        timeout=180.0,
    )
    if code == 0:
        return True, ""
    return False, (err2 or err).strip()


def remove_from_system(item: DriftItem, show_progress: bool = False) -> RemoveResult:
    if item.kind == "tap":
        title = f"Untapping {item.name}..." if show_progress else None
        code, _, err = run_with_title(["brew", "untap", item.name], title=title)
    elif item.kind == "brew":
        title = f"Running: brew uninstall {item.name}" if show_progress else None
        code, err = run_live(
            ["brew", "uninstall", item.name],
            title=title,
            timeout=180.0,
        )
        if code != 0 and _is_not_installed_error(err):
            return RemoveResult(ok=True, message=f"brew {item.name} already not installed")
    elif item.kind == "cask":
        title = f"Running: brew uninstall --cask {item.name}" if show_progress else None
        code, err = run_live(
            ["brew", "uninstall", "--cask", item.name],
            title=title,
            timeout=180.0,
        )
        if code != 0 and _is_not_installed_error(err):
            alias = resolve_cask_alias(item.name)
            if alias and alias != item.name:
                retry_title = f"Running: brew uninstall --cask {alias} (alias for {item.name})" if show_progress else None
                code, err = run_live(
                    ["brew", "uninstall", "--cask", alias],
                    title=retry_title,
                    timeout=180.0,
                )
            if code != 0 and _is_not_installed_error(err):
                return RemoveResult(ok=True, message=f"cask {item.name} already not installed")
        if code != 0 and "is unavailable" in err.lower():
            alias = resolve_cask_alias(item.name)
            if alias and alias != item.name:
                retry_title = f"Running: brew uninstall --cask {alias} (alias for {item.name})" if show_progress else None
                code, err = run_live(
                    ["brew", "uninstall", "--cask", alias],
                    title=retry_title,
                    timeout=180.0,
                )
    elif item.kind == "mas" and item.mas_id is not None:
        title = f"Running: mas uninstall {item.mas_id} ({item.name})" if show_progress else None
        code, err = run_live(
            ["mas", "uninstall", str(item.mas_id)],
            title=title,
            timeout=180.0,
            use_spinner=False,
        )
        if code != 0 and _is_not_installed_error(err):
            return RemoveResult(ok=True, message=f"mas {item.name} already not installed")
    else:
        return RemoveResult(ok=False, message=f"Unsupported remove kind: {item.kind}")

    if code != 0:
        blockers = parse_untap_blockers(err) if item.kind == "tap" else ()
        return RemoveResult(
            ok=False,
            message=f"Failed to remove {item.kind} {item.name}: {err.strip()}",
            blockers=blockers,
        )
    return RemoveResult(ok=True)


def report(items: list[DriftItem]) -> int:
    if not items:
        print("No package drift found.")
        print("Compared installed local packages against home/.chezmoidata/packages-darwin.toml.")
        return 0

    grouped: dict[str, list[DriftItem]] = {"tap": [], "brew": [], "cask": [], "mas": []}
    for item in items:
        grouped.setdefault(item.kind, []).append(item)

    print("Package drift report")
    print("Meaning: installed locally on this Mac, but not tracked in dotfiles.")
    print(f"Tracked file: {PACKAGES_FILE.relative_to(ROOT)}")
    print(f"Untracked installed items: {len(items)}")

    labels = [("tap", "Taps"), ("brew", "Brews"), ("cask", "Casks"), ("mas", "Mac App Store")]
    for kind, label in labels:
        bucket = grouped.get(kind, [])
        if not bucket:
            continue
        print("")
        print(f"{label} ({len(bucket)}):")
        for entry in bucket:
            if kind == "mas" and entry.mas_id is not None:
                print(f"  - {entry.name} [{entry.mas_id}]")
            else:
                print(f"  - {entry.name}")

    print("")
    print("Run `mise run packages:reconcile` to review actions interactively.")
    return 0


def reconcile(items: list[DriftItem]) -> int:
    if not command_exists("gum"):
        print("gum is required for interactive mode.", file=sys.stderr)
        return 2
    if not items:
        print("No drift found.")
        return 0

    print("Reconciling installed local packages missing from dotfiles.")
    print("Choose: skip, add to dotfiles, uninstall/untap, or quit.")
    print(f"Items to review: {len(items)}")

    added = 0
    removed = 0
    skipped = 0
    errors = 0

    try:
        for idx, item in enumerate(items, start=1):
            item = with_description(item)
            action = gum_choose(item, idx, len(items))
            if action == "skip":
                skipped += 1
                continue
            if action == "quit":
                print("Quit requested. Stopping reconcile.")
                return 130

            if action == "add to dotfiles":
                if add_to_dotfiles(item):
                    added += 1
                else:
                    skipped += 1
                continue

            if action in {"uninstall", "untap"}:
                remove_verb = "untap" if item.kind == "tap" else "uninstall"
                if not gum_confirm(f"{remove_verb} {item.kind} {item.name}?"):
                    skipped += 1
                    continue
            print(f"Running action: {remove_verb} {item.kind} {item.name}")
            result = remove_from_system(item, show_progress=True)
            if result.ok:
                removed += 1
            else:
                handled = False
                if item.kind == "tap" and result.blockers:
                    print(
                        f"Untap blocked for {item.name}. Installed from this tap: {', '.join(result.blockers)}",
                        file=sys.stderr,
                    )
                    if gum_confirm("Uninstall blockers and retry untap?"):
                        failed_blockers: list[str] = []
                        for blocker in result.blockers:
                            print(f"Running action: uninstall blocker {blocker} (for tap {item.name})")
                            ok, blocker_err = uninstall_blocker(blocker, tap_name=item.name)
                            if not ok:
                                failed_blockers.append(f"{blocker}: {blocker_err}")
                        if failed_blockers:
                            print("Failed to uninstall blocker(s):", file=sys.stderr)
                            for entry in failed_blockers:
                                print(f"- {entry}", file=sys.stderr)
                        else:
                            print(f"Running action: retry untap tap {item.name}")
                            retry = remove_from_system(item, show_progress=True)
                            if retry.ok:
                                removed += 1
                                handled = True
                            else:
                                print(retry.message or "Failed to untap after retry.", file=sys.stderr)
                if not handled:
                    print(result.message or "Remove action failed.", file=sys.stderr)
                    errors += 1
                continue

            skipped += 1
    except KeyboardInterrupt:
        print("\nCancelled.", file=sys.stderr)
        return 130

    print(f"Done. added={added} removed={removed} skipped={skipped} errors={errors}")
    return 0 if errors == 0 else 1


def print_missing_dependencies() -> None:
    if not command_exists("brew"):
        print("Note: brew not found, skipping taps/brews/casks checks.", file=sys.stderr)
    if not command_exists("mas"):
        print("Note: mas not found, skipping App Store checks.", file=sys.stderr)


def _extract_comment_text(raw_line: str) -> str | None:
    stripped = raw_line.strip()
    if not stripped.startswith("#"):
        return None
    text = stripped[1:].strip()
    return text or None


def _parse_array_records(lines: list[str], start: int) -> tuple[int, list[ArrayRecord]]:
    records: list[ArrayRecord] = []
    comment_buffer: list[str] = []
    i = start + 1

    while i < len(lines):
        stripped = lines[i].strip()
        if stripped == "]":
            return i, records
        if not stripped:
            i += 1
            continue
        if stripped.startswith("#"):
            text = _extract_comment_text(lines[i])
            if text:
                comment_buffer.append(text)
            i += 1
            continue

        match = re.match(r'^\s*"([^"]+)",\s*(?:#\s*(.*))?$', lines[i])
        if match:
            name = match.group(1)
            inline_comment = (match.group(2) or "").strip() or None
            comment: str | None
            if comment_buffer:
                comment = " ".join(comment_buffer).strip()
            else:
                comment = inline_comment
            records.append(ArrayRecord(name=name, comment=comment))
            comment_buffer = []
        i += 1

    raise RuntimeError("Could not find closing ] for array block")


def _render_array_records(records: list[ArrayRecord]) -> list[str]:
    out: list[str] = []
    for record in records:
        comment = _sanitize_comment(record.comment)
        if comment:
            out.append(f"    # {comment}\n")
        out.append(f'    "{record.name}",\n')
    return out


def _description_for_kind(kind: str, name: str) -> str | None:
    if kind == "taps":
        return describe_tap(name, show_progress=True)
    if kind == "brews":
        return describe_brew_formula(name, show_progress=True)
    if kind == "casks":
        return describe_brew_cask(name, show_progress=True)
    return None


def _prettify_array_block(content: str, key: str) -> tuple[str, int]:
    lines = content.splitlines(keepends=True)
    start = -1
    start_pattern = re.compile(rf"^\s*{re.escape(key)}\s*=\s*\[\s*$")
    for i, line in enumerate(lines):
        if start_pattern.match(line):
            start = i
            break
    if start < 0:
        return content, 0

    end, records = _parse_array_records(lines, start)
    if not records:
        return content, 0

    changed = 0
    for record in records:
        if not record.comment:
            desc = _description_for_kind(key, record.name)
            if desc:
                record.comment = desc
                changed += 1

    sorted_records = sorted(records, key=lambda x: x.name.lower())
    if [r.name for r in sorted_records] != [r.name for r in records]:
        changed += 1

    rendered = _render_array_records(sorted_records)
    new_lines = lines[: start + 1] + rendered + lines[end:]
    return "".join(new_lines), changed


def prettify_packages_file() -> int:
    if not PACKAGES_FILE.exists():
        print(f"Missing file: {PACKAGES_FILE}", file=sys.stderr)
        return 2

    content = PACKAGES_FILE.read_text(encoding="utf-8")
    total_changes = 0

    for key in ("taps", "brews", "casks"):
        content, changes = _prettify_array_block(content, key)
        total_changes += changes

    if total_changes == 0:
        print("No prettify changes needed.")
        return 0

    PACKAGES_FILE.write_text(content, encoding="utf-8")
    print(f"Prettified packages-darwin.toml. Updated entries: {total_changes}")
    return 0


def main(mode: str) -> int:
    if sys.platform != "darwin":
        print("This task only supports macOS.", file=sys.stderr)
        return 2
    if not PACKAGES_FILE.exists():
        print(f"Missing file: {PACKAGES_FILE}", file=sys.stderr)
        return 2

    print_missing_dependencies()
    if mode == "prettify":
        return prettify_packages_file()

    items = collect_drift(show_progress=True)
    if mode == "report":
        return report(items)
    if mode == "reconcile":
        return reconcile(items)
    print("Mode must be 'report', 'reconcile', or 'prettify'.", file=sys.stderr)
    return 2
