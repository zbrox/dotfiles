# Path to your dotfiles installation.
export DOTFILES=$HOME/.dotfiles

# Read private env variables files (not in repo)
[ -r $DOTFILES/.env_private ] && source $DOTFILES/.env_private

# Load aliases
source $DOTFILES/aliases.zsh

# zsh history
export HISTSIZE=5000
export HISTFILE="$HOME/.zsh-history"
export SAVEHIST=$HISTSIZE
setopt SHARE_HISTORY

# Preferred editor
export EDITOR='vim'

# Set vim keybindings
bindkey -v

# You may need to manually set your language environment
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# cairo
export PKG_CONFIG_PATH=PKG_CONFIG_PATH:/opt/X11/lib/pkgconfig

# fix the python path warning
unset PYTHONPATH

# nvm
export NVM_DIR="$HOME/.nvm"
source "/usr/local/opt/nvm/nvm.sh"

# homebrew
export HOMEBREW_AUTO_UPDATE_SECS=3600
export PATH="/usr/local/sbin:$PATH"
export HOMEBREW_GITHUB_API_TOKEN=$HOMEBREW_GITHUB_API_TOKEN

# cargo/rust
export PATH="$HOME/.cargo/bin:$PATH"

# zplug
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# zsh completions
zplug "plugins/git", from:oh-my-zsh, if:"(( $+commands[git] ))"
zplug "plugins/git-flow", from:oh-my-zsh, if:"(( $+commands[git] ))"

zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/osx", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/colorize", from:oh-my-zsh
zplug "lukechilds/zsh-better-npm-completion"
zplug "plugins/cargo", from:oh-my-zsh
zplug "zsh-users/zsh-completions"

# zsh plugins
zplug "zsh-users/zsh-history-substring-search", defer:3
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "tysonwolker/iterm-tab-colors", defer:2
zplug "jimeh/zsh-peco-history", defer:3
zplug "paulmelnikow/zsh-startup-timer", defer:2


# Load theme file
# zplug 'themes/ys', from:oh-my-zsh, as:theme
zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme

# check if all plugins are installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

# Set the autocd option of zsh
setopt AUTOCD

export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/icu4c/sbin:$PATH"

fpath=(~/.zsh $fpath)

# direnv
eval "$(direnv hook zsh)"

# qt
export PATH="/usr/local/opt/qt/bin:$PATH"

# ssl headers fix
export OPENSSL_INCLUDE_DIR=`brew --prefix openssl`/include
export OPENSSL_LIB_DIR=`brew --prefix openssl`/lib
export DEP_OPENSSL_INCLUDE=`brew --prefix openssl`/include