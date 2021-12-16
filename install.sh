#!/usr/bin/env bash

echo "Setting up your Mac..."

# Ask for the administrator password upfront
echo "Admin password:"
sudo -v

# Check for Homebrew and install if we don't have it
if test ! "$(which brew)"; then
  echo "Installing Homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Homebrew already installed."
fi

# Update Homebrew recipes
echo "Updating Homebrew recipes..."
brew update

# Install fish
echo "Installing Fish shell..."
brew install fish
# Make Fish the default shell
if ! grep -Fxq "$(which fish)" /etc/shells; then
  echo "Adding $(which fish) to list of shells..."
  echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
fi
if ! grep -Fxq "$(which fish)" /etc/shells; then
  echo "There was no error but still $(which fish) is not in /etc/shells. Add manually and rerun install script."
  exit 1
fi

echo "Setting Fish as the default shell for the user..."
chsh -s "$(which fish)"

# Install mas for installing from the Mac App Store
echo "Installing Mac App Store install utility..."
brew install mas

# install Xcode separately
echo "Installing Xcode..."
mas install 497799835

echo "Confirm the accepting of the Xcode license"
sudo xcodebuild -license accept

# Install all our dependencies with bundle (See Brewfile)
echo "Installing programs listed in Brewfile..."
brew tap homebrew/bundle
brew bundle install --file macos/Brewfile

# Set macOS preferences
# We will run this last because this will reload the shell
echo "Setting up macOS preferences..."
source macos/.macos

echo "Installation done!"
echo "Now run symlink.fish"
