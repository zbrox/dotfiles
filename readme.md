# My dotfiles

Thanks to [driesvints](https://github.com/driesvints) whose [dotfiles](https://github.com/driesvints/dotfiles) these were originally based on. That's what got me started! So after some heavy evolution over the years, this is what it is now.

## What's in the box

* Installing [Homebrew](https://brew.sh), Xcode (unfortunately needed for a lot of things) and setting up Fish as the default shell
* Setting up some macOS specific stuff
* Configurations
  * [Fish](http://fishshell.com) as the default shell, with some handy functions, autocompletions, plugins, and [Fisher](https://github.com/jorgebucaran/fisher) for a plugin manager
  * [Starship](https://starship.rs) for a prompt
  * [Alacritty](https://github.com/alacritty/alacritty) for a terminal emulator
  * [Git](https://git-scm.com) Duh! Setting up a global gitignore, commit message template, some aliases, and some configurations options I'm used to
  * [VSCode](https://code.visualstudio.com) settings and snippets
  * [tmux](https://github.com/tmux/tmux) config, which has its own [readme](https://github.com/zbrox/dotfiles/blob/master/tmux/README.md)
* Installing a bunch of software through the Homebrew bundle or if needed through the Mac App Store

## Setup

Run `install.sh` and once that script is done you can symlink by running `symlink.fish`.
