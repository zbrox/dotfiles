#!/usr/bin/env fish

set -x DOTFILES $HOME/.dotfiles

function symlink_file --argument dotfile --argument destination
    if test -e $destination
        echo "The destination file $destination already exists"
    else
        echo "Linking $DOTFILES/$dotfile to $destination"
        ln -s $DOTFILES/$dotfile $destination
    end
end

function symlink_dir --argument dotdir --argument destination
    if test -e $destination
        echo "The destination folder $destination already exists"
    else
        echo "Linking folder $DOTFILES/$dotdir to $destination"
        ln -s $DOTFILES/$dotfile $destination
    end
end

# make sure ~/.config exists
mkdir -p ~/.config

# Git
symlink_file git/.gitconfig ~/.gitconfig

# VSCode
symlink_file vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
symlink_dir vscode/snippets ~/Library/Application\ Support/Code/User/snippets

# Fish
symlink_dir fish ~/.config/fish

# Starship
symlink_file starship/starship.toml ~/.config/starship.toml

# Alacritty
symlink_dir alacritty ~/.config/alacritty

# Tmux
if test -e ~/.tmux.conf
    echo "Skipping tmux configuration install since ~/.tmux.conf already exists."
else
    echo "Running tmux config install..."
    fenv source $DOTFILES/tmux/install.sh
end

echo "Done!"