#!/bin/sh

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

# install Xcode separately
brew install mas
mas install 497799835
sudo xcodebuild -license accept

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

# Make ZSH the default shell environment
# don't forget to add $(which fish) to /etc/shells
chsh -s $(which fish)

# Set macOS preferences
# We will run this last because this will reload the shell
source .macos
