#!/usr/bin/env bash

set -euo pipefail

readonly DOTFILES_REPOSITORY="https://github.com/zbrox/dotfiles.git"
readonly DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
readonly MISERC_FILE="$HOME/.miserc.toml"
readonly LOCAL_CONFIG="$DOTFILES_DIR/mise.local.toml"

usage() {
    cat <<'EOF'
Usage: install.sh [--base | --gui]

  --base  Install command-line tools and dotfiles
  --gui   Install the Base profile plus graphical applications and settings
EOF
}

die() {
    printf 'Error: %s\n' "$*" >&2
    exit 1
}

select_profile() {
    case "${1:-}" in
        --base)
            profile="base"
            ;;
        --gui)
            profile="gui"
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        "")
            [[ -r /dev/tty ]] || die "pass --base or --gui when running without a terminal"
            printf 'Select a profile:\n  1) Base\n  2) Base + GUI\n> ' >/dev/tty
            read -r selection </dev/tty
            case "$selection" in
                1) profile="base" ;;
                2) profile="gui" ;;
                *) die "choose 1 for Base or 2 for Base + GUI" ;;
            esac
            ;;
        *)
            usage >&2
            die "unknown argument: $1"
            ;;
    esac

    (($# <= 1)) || die "pass only one profile"
}

write_managed_file() {
    local path="$1"
    local content="$2"
    local label="$3"
    local temporary

    mkdir -p "$(dirname "$path")"
    temporary="$(mktemp "${path}.tmp.XXXXXX")"
    printf '%s' "$content" >"$temporary"

    if [[ -e "$path" ]]; then
        if cmp -s "$temporary" "$path"; then
            rm "$temporary"
            return
        fi
        rm "$temporary"
        die "$label already exists with different contents: $path"
    fi

    mv "$temporary" "$path"
}

find_homebrew() {
    if command -v brew >/dev/null 2>&1; then
        command -v brew
    elif [[ -x /opt/homebrew/bin/brew ]]; then
        printf '%s\n' /opt/homebrew/bin/brew
    elif [[ -x /usr/local/bin/brew ]]; then
        printf '%s\n' /usr/local/bin/brew
    fi
}

verify_checkout() {
    local origin

    [[ -d "$DOTFILES_DIR/.git" ]] || die "$DOTFILES_DIR exists but is not a Git checkout"
    origin="$(git -C "$DOTFILES_DIR" remote get-url origin 2>/dev/null)" || \
        die "$DOTFILES_DIR has no origin remote"

    case "$origin" in
        https://github.com/zbrox/dotfiles.git|git@github.com:zbrox/dotfiles.git)
            ;;
        *)
            die "$DOTFILES_DIR has an unexpected origin: $origin"
            ;;
    esac
}

select_profile "$@"

[[ "$(uname -s)" == "Darwin" ]] || die "this installer currently supports macOS only"

if ! xcode-select -p >/dev/null 2>&1; then
    xcode-select --install
    printf 'Finish installing the Xcode Command Line Tools, then run this installer again.\n'
    exit 1
fi

brew_path="$(find_homebrew)"
if [[ -z "$brew_path" ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew_path="$(find_homebrew)"
    [[ -n "$brew_path" ]] || die "Homebrew was installed but brew could not be found"
fi

eval "$("$brew_path" shellenv)"

if ! command -v mise >/dev/null 2>&1; then
    "$brew_path" install mise
fi
mise_path="$(command -v mise)"

run_mise() {
    if [[ "$profile" == "gui" ]]; then
        "$mise_path" -E gui "$@"
    else
        "$mise_path" "$@"
    fi
}

if [[ "$profile" == "gui" ]]; then
    miserc_content=$'env = ["gui"]\n'
else
    miserc_content=$'env = []\n'
fi
write_managed_file "$MISERC_FILE" "$miserc_content" "mise profile configuration"

if [[ -e "$DOTFILES_DIR" ]]; then
    [[ -d "$DOTFILES_DIR" ]] || die "$DOTFILES_DIR exists but is not a directory"
    verify_checkout
    "$mise_path" -C "$DOTFILES_DIR" trust --all
    run_mise -C "$DOTFILES_DIR" bootstrap --skip user --yes
else
    run_mise bootstrap \
        --from "$DOTFILES_REPOSITORY" \
        --from-dir "$DOTFILES_DIR" \
        --skip user \
        --yes
fi

eval "$("$brew_path" shellenv)"
fish_path="$(command -v fish || true)"
[[ -n "$fish_path" && "$fish_path" == /* && -x "$fish_path" ]] || \
    die "Fish was not installed at an executable absolute path"

local_config_content="$(printf '[bootstrap.user]\nlogin_shell = \"%s\"\n' "$fish_path")"$'\n'
write_managed_file "$LOCAL_CONFIG" "$local_config_content" "local bootstrap configuration"

run_mise -C "$DOTFILES_DIR" bootstrap user apply --yes

jj_path="$(command -v jj || true)"
[[ -n "$jj_path" ]] || die "Jujutsu was not installed"
if [[ ! -d "$DOTFILES_DIR/.jj" ]]; then
    "$jj_path" git init --colocate "$DOTFILES_DIR"
fi

cat <<EOF

Bootstrap complete.

Before using SSH-backed Git remotes:
  1. Enable the SSH agent in 1Password.
  2. Add IdentityAgent "~/.1password/agent.sock" to ~/.ssh/config.
  3. Optionally switch this checkout to SSH:
     jj -R "$DOTFILES_DIR" git remote set-url origin git@github.com:zbrox/dotfiles.git

Start a new login session to use Fish as your login shell.
EOF
