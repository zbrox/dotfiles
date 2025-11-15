# A lot of this shamelessly copied from Pascal
# https://github.com/killercup/pascastle/blob/master/home/.config/fish/conf.d/env_vars.fish

if test (uname) = Darwin
    fish_add_path /opt/homebrew/bin $PATH # prefer arm64 brews
    fish_add_path /usr/local/bin $PATH # prefer brews
    fish_add_path /usr/local/sbin
end

fish_add_path $HOME/.bin $PATH # prefer user binaries even more
fish_add_path $HOME/.local/bin $PATH # prefer user binaries even more

# Dotfiles
set -x DOTFILES $HOME/.dotfiles

# Cargo
fish_add_path $HOME/.cargo/bin
if test (uname) = Darwin
    fish_add_path /opt/homebrew/opt/rustup/bin # brew keeps unlinking this
end
set -x CARGO_TARGET_DIR $HOME/.cargo/global-target

# Go
set -x GOPATH $HOME/.go
fish_add_path $GOPATH/bin

# Add _current_ folder's node modules
fish_add_path ./node_modules/.bin

# Use local bin folder, e.g. for virtualenv
set -x PATH ./bin $PATH

if test (uname) = Darwin
    # QT
    fish_add_path /usr/local/opt/qt/bin

    # Homebrew
    set -x HOMEBREW_AUTO_UPDATE_SECS 3600

    # Fix some issues with openssl and homebrew
    set -x DYLD_FALLBACK_LIBRARY_PATH /usr/local/opt/openssl/lib
end

# load private env file
if test -f $DOTFILES/.env_private
    echo "Loading private env vars from $DOTFILES/.env_private"
    posix-source $DOTFILES/.env_private
end

# Locales
set -x LC_ALL en_US.UTF-8
set -x LANG en_US.UTF-8
set -x LANGUAGE en_US.UTF-8

# Editor
set -x EDITOR vim

if test (uname) = Darwin
    # Homebrew OpenSSL headers fixes
    if type -q brew
        set -x OPENSSL_INCLUDE_DIR (brew --prefix openssl)/include
        set -x OPENSSL_LIB_DIR (brew --prefix openssl)/lib
    end

    if test (uname -p) = arm
        set -x LDFLAGS -L(brew --prefix openssl)/lib
        set -x CPPFLAGS -I(brew --prefix openssl)/include
    end
end

if test (uname) = Darwin
    # 1password ssh agent
    if test -x /Applications/1Password.app/Contents/MacOS/1Password
        if not test -d ~/.1password
            mkdir -p ~/.1password
        end
        if test -f ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
            ln -s ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ~/.1password/agent.sock
        end
        set SSH_AUTH_SOCK ~/.1password/agent.sock
    end
end
