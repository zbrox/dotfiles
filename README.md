# Dotfiles

Personal configuration managed by [mise](https://mise.jdx.dev/) and versioned with [Jujutsu](https://jj-vcs.github.io/jj/).

Thanks to [driesvints](https://github.com/driesvints), whose [dotfiles](https://github.com/driesvints/dotfiles) originally provided the starting point for this repository.

## Profiles

The Base profile contains terminal and development configuration, including Fish, Git, jj, mise, Atuin, Starship, Neovim, Helix, Yazi, and Zellij.

The GUI profile adds graphical application configuration for Ghostty, WezTerm, Zed, Kanata, Karabiner, and QMK. Resources within either profile carry their own operating-system restrictions, so selecting GUI does not imply macOS.

The selected profile is stored locally in `~/.miserc.toml`. Base uses:

```toml
env = []
```

Base with GUI uses:

```toml
env = ["gui"]
```

## Setup

The installer clones the repository to `~/.dotfiles`, applies the selected configuration, and initializes the checkout as a collocated jj repository.

### macOS

Run either profile directly:

```sh
curl -fsSL https://raw.githubusercontent.com/zbrox/dotfiles/master/install.sh | bash -s -- --base
curl -fsSL https://raw.githubusercontent.com/zbrox/dotfiles/master/install.sh | bash -s -- --gui
```

Running without a profile prompts for one:

```sh
curl -fsSL https://raw.githubusercontent.com/zbrox/dotfiles/master/install.sh | bash
```

The installer bootstraps the selected profile and prints any remaining manual steps when it finishes.

### Linux

Git, Fish, jj, and curl must be supplied by the system configuration. The installer reuses mise when available or installs its portable binary under `~/.local/bin`.

```sh
curl -fsSL https://raw.githubusercontent.com/zbrox/dotfiles/master/install.sh | bash -s -- --base
curl -fsSL https://raw.githubusercontent.com/zbrox/dotfiles/master/install.sh | bash -s -- --gui
```

With no profile argument, Linux selects Base. Linux setup applies the selected dotfiles and configures the Fish login shell; system packages and development tools remain owned by the distribution or Nix configuration.

## Repository layout

- `mise.toml` contains shared settings and tools.
- `mise.gui.toml` contains the additive GUI profile.
- `.mise/conf.d/` contains Base packages, tools, dotfile declarations, and bootstrap tasks.
- `src/` mirrors the destination paths for copy-mode dotfiles.
- `mise.local.toml` is ignored and stores the machine-specific absolute Fish path used for login-shell setup.

## Updating dotfiles

Edit managed files in the home directory, then inspect and capture those changes:

```sh
jj -R ~/.dotfiles new -m "wip: update dotfiles"
mise -C ~/.dotfiles dot diff
mise -C ~/.dotfiles dot add --changed --no-apply
jj -R ~/.dotfiles diff
jj -R ~/.dotfiles desc -m "chore: update dotfiles"
```

Advance and push the intended bookmark after reviewing the revision:

```sh
jj -R ~/.dotfiles bookmark set master -r @
jj -R ~/.dotfiles git push -b master
```

Before applying repository changes, inspect differences against the live files:

```sh
mise -C ~/.dotfiles dot diff
mise -C ~/.dotfiles dot apply
```

Run `mise -C ~/.dotfiles bootstrap` when a revision also changes packages, tools, plugins, or machine settings.
