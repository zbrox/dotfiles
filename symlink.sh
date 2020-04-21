#! /bin/bash

DOTFILES=~/.dotfiles

# ZSH
if [ -e ~/.zshrc ]; then
	echo ".zshrc already exists"
else
	ln -s $DOTFILES/.zshrc ~/.zshrc
fi

# GIT
if [ -e ~/.gitconfig ]; then
        echo ".gitconfig already exists"
else
        ln -s $DOTFILES/.gitconfig ~/.gitconfig
fi

# VSCode
if [ ! -d ~/Library/Application\ Support/Code/User ]; then
	echo "VSCode settings folder does not exist. Check if you installed VSCode and it has been launched at least once."
else
	if [ ! -e ~/Library/Application\ Support/Code/User/settings.json ]; then
		ln -s $DOTFILES/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
	else
		echo "VSCode settings.json exists. Remove it and rerun."
	fi
	if [ ! -d ~/Library/Application\ Support/Code/User/snippets ]; then
		ln -s $DOTFILES/vscode/snippets ~/Library/Application\ Support/Code/User/snippets
	else
		echo "VSCode snippets folder exists. Remove it and rerun."
	fi
fi

# Fish
if [ -e ~/.config/fish ]; then
	echo "~/.config/fish already exists"
else
    mkdir -p ~/.config
	ln -s $DOTFILES/fish ~/.config/fish
fi