# My dotfiles

Thanks to [driesvints](https://github.com/driesvints) whose [dotfiles](https://github.com/driesvints/dotfiles) these were originally based on. That's what got me started! So after some heavy evolution over the years, this is what it is now.

Current iteration uses [chezmoi](https://www.chezmoi.io/) to manage everything.

## What's in the box

- Setting up platform-specific configurations (macOS, Linux including NixOS)
- Installing software using Homebrew bundle on macOS or through the Mac App Store
- Install rustup (except on NixOS)
- Install cargo binaries (except on NixOS)
- Configurations
  - [Fish](http://fishshell.com) as the default shell, with some handy functions, autocompletions, plugins, and [Fisher](https://github.com/jorgebucaran/fisher) for a plugin manager
  - [Starship](https://starship.rs) for a prompt
  - [Neovim](https://neovim.io/) settings and plugins
  - [Helix](https://helix-editor.com/) configuration
  - [Wezterm](https://wezfurlong.org/wezterm/index.html) very basic settings of the cross platform terminal emulator (GUI only)
  - [Git](https://git-scm.com) Duh! Setting up a global gitignore, commit message template, some aliases, and some configurations options I'm used to
  - [jj (Jujutsu)](https://github.com/martinvonz/jj) configuration for this version control system
  - [VSCode](https://code.visualstudio.com) settings and extensions (GUI only)
  - [zed](https://zed.dev) settings only (GUI only)
  - [Zellij](https://zellij.dev) basic settings for this amazing terminal multiplexer
  - [Atuin](https://atuin.sh) almost the default settings for atuin, a better history for your shell
  - [Yazi](https://yazi-rs.github.io/) terminal file manager configuration
  - [mise](https://mise.jdx.dev/) configuration for this dev tools version manager
  - [Karabiner](https://karabiner-elements.pqrs.org/) keyboard remapping (macOS only)
  - [Kanata](https://github.com/jtroo/kanata) keyboard remapping configuration (GUI only)
  - [QMK](https://qmk.fm/) basic user settings to set the default keyboard and layout which I have made for myself (macOS only)

## Setup

### macOS

Requirements: [homebrew](https://brew.sh/) and [chezmoi](https://www.chezmoi.io/)

Steps:

1. Install homebrew - `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
2. Install chezmoi - `brew install chezmoi`
3. Init dotfiles - `chezmoi init --apply zbrox`

### Linux (including NixOS)

Requirements: [chezmoi](https://www.chezmoi.io/)

Steps:

1. Install chezmoi - Follow [installation instructions](https://www.chezmoi.io/install/) for your distro
2. Init dotfiles - `chezmoi init --apply zbrox`

On first run, you'll be prompted whether this is a GUI or headless system to configure appropriate tools.
