# A lot of this shamelessly copied from Pascal 
# https://github.com/killercup/pascastle/blob/master/home/.config/fish/conf.d/env_vars.fish

set -x PATH /opt/homebrew/bin $PATH # prefer arm64 brews
set -x PATH /usr/local/bin $PATH # prefer brews
set -x PATH $HOME/.bin $PATH # prefer user binaries even more
set -x PATH $HOME/.local/bin $PATH # prefer user binaries even more
set -x PATH $PATH /usr/local/sbin

# Dotfiles
set -x DOTFILES $HOME/.dotfiles

# Cargo
set -x PATH $PATH $HOME/.cargo/bin
set -x CARGO_TARGET_DIR $HOME/.cargo/global-target

# Add _current_ folder's node modules
set -x PATH $PATH ./node_modules/.bin

# Use local bin folder, e.g. for virtualenv
set -x PATH ./bin $PATH

# QT
set -x PATH $PATH /usr/local/opt/qt/bin

# Homebrew
set -x HOMEBREW_AUTO_UPDATE_SECS 3600

# Fix some issues with openssl and homebrew
set -x DYLD_FALLBACK_LIBRARY_PATH /usr/local/opt/openssl/lib

# load private env file
posix-source $DOTFILES/.env_private

# Locales
set -x LC_ALL en_US.UTF-8
set -x LANG en_US.UTF-8
set -x LANGUAGE en_US.UTF-8

# Editor
set -x EDITOR 'vim'

# Homebrew OpenSSL headers fixes
if type -q brew
	set -l __brew_prefix_openssl /usr/local/opt/openssl # (brew --prefix openssl)
	set -x OPENSSL_INCLUDE_DIR $__brew_prefix_openssl/include
	set -x OPENSSL_LIB_DIR $__brew_prefix_openssl/lib
end

if test (uname -p) = "arm"
	set -x LDFLAGS -L(brew --prefix openssl)/lib
	set -x CPPFLAGS -I(brew --prefix openssl)/include
end