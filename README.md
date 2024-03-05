# My dotfiles

Thanks to [driesvints](https://github.com/driesvints) whose [dotfiles](https://github.com/driesvints/dotfiles) these were originally based on. That's what got me started! So after some heavy evolution over the years, this is what it is now.

Current iteration uses [chezmoi](https://www.chezmoi.io/) to manage everything.

## What's in the box

* Setting up some macOS specific stuff
* Configurations
  * [Fish](http://fishshell.com) as the default shell, with some handy functions, autocompletions, plugins, and [Fisher](https://github.com/jorgebucaran/fisher) for a plugin manager
  * [Starship](https://starship.rs) for a prompt
  * [Neovim](https://neovim.io/) settings and plugins
  * [Wezterm](https://wezfurlong.org/wezterm/index.html) settings of the cross platform terminal emulator
  * [Git](https://git-scm.com) Duh! Setting up a global gitignore, commit message template, some aliases, and some configurations options I'm used to
  * [VSCode](https://code.visualstudio.com) settings and extensions
  * [tmux](https://github.com/tmux/tmux) config, which has its own [readme](https://github.com/zbrox/dotfiles/blob/master/tmux/README.md)
* Installing a bunch of software through the Homebrew bundle or if needed through the Mac App Store

## Setup

There are only 2 requirements - [homebrew](https://brew.sh/) and [chezmoi](https://www.chezmoi.io/).

Steps:

1. Install homebrew - `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
2. Install chezmoi - `brew install chezmoi`
3. Init dotfiles - `chezmoi init --apply zbrox`
