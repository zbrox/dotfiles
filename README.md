# My dotfiles

Thanks to [driesvints](https://github.com/driesvints) whose [dotfiles](https://github.com/driesvints/dotfiles) these were originally based on. That's what got me started! So after some heavy evolution over the years, this is what it is now.

Current iteration uses [chezmoi](https://www.chezmoi.io/) to manage everything.

## What's in the box

- Setting up some macOS specific stuff
- Installing a bunch of software using Homebrew bundle or if needed through the Mac App Store
- Install rustup
- Configurations
  - [Fish](http://fishshell.com) as the default shell, with some handy functions, autocompletions, plugins, and [Fisher](https://github.com/jorgebucaran/fisher) for a plugin manager
  - [Starship](https://starship.rs) for a prompt
  - [Neovim](https://neovim.io/) settings and plugins
  - [Wezterm](https://wezfurlong.org/wezterm/index.html) very basic settings of the cross platform terminal emulator, which is what I currently use
  - [Git](https://git-scm.com) Duh! Setting up a global gitignore, commit message template, some aliases, and some configurations options I'm used to
  - [VSCode](https://code.visualstudio.com) settings and extensions
  - [zed](https://zed.dev) settings only
  - [zellij](https://zellij.dev) basic settings for this amazing terminal multiplexer
  - [atuin](https://atuin.sh) almost the default settings for atuin, a better history for your shell
  - [qmk](https://qmk.fm/) basic user settings to set the default keyboard and layout which I have made for myself

## Setup

There are only 2 requirements - [homebrew](https://brew.sh/) and [chezmoi](https://www.chezmoi.io/).

Steps:

1. Install homebrew - `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
2. Install chezmoi - `brew install chezmoi`
3. Init dotfiles - `chezmoi init --apply zbrox`
