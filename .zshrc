# Path to your dotfiles installation.
export DOTFILES=$HOME/.dotfiles

# Load aliases
source $DOTFILES/aliases.zsh

# Preferred editor
export EDITOR='vim'

# You may need to manually set your language environment
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# cairo
export PKG_CONFIG_PATH=PKG_CONFIG_PATH:/opt/X11/lib/pkgconfig

# fix the python path warning
unset PYTHONPATH

# yarn global path
export PATH="$(yarn global bin | grep -o '/.*'):$PATH"

# nvm
export NVM_DIR="$HOME/.nvm"
source "/usr/local/opt/nvm/nvm.sh"

# homebrew
export HOMEBREW_AUTO_UPDATE_SECS=3600

# cargo/rust
export PATH="$HOME/.cargo/bin:$PATH"

# zplug
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# zsh completions
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/git-flow", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/osx", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/colorize", from:oh-my-zsh

# zsh plugins
zplug "zsh-users/zsh-history-substring-search", defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions", defer:2

# Load theme file
# zplug 'themes/ys', from:oh-my-zsh, as:theme
zplug denysdovhan/spaceship-prompt, use:spaceship.zsh, from:github, as:theme

# check if all plugins are installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load
