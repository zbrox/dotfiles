# Direnv
eval (direnv hook fish)

# Fisher package manager
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# Starship prompt
starship init fish | source

# Atuin
atuin init fish | source

# initialize nix
if test -e "$HOME/.nix-profile/etc/profile.d/nix.sh"
    fenv source "$HOME/.nix-profile/etc/profile.d/nix.sh"
end

# # setup nix-darwin
# if test -e /etc/static/fish/config.fish
#     source /etc/static/fish/config.fish
# end

# rye
if test -e "$HOME/.rye/env"
    fenv source "$HOME/.rye/env"
end

# 1password integration
if test -e "$HOME/.config/op/plugins.sh"
    source ~/.config/op/plugins.sh
end

# activate mise if installed
if type mise >/dev/null 2>&1
    mise activate fish | source
end

# setup zoxide
zoxide init fish | source

# setup zellij completions
zellij setup --generate-completion fish | source

# fish vi mode
fish_vi_key_bindings
