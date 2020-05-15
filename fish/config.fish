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

# initialize nix
fenv source "$HOME/.nix-profile/etc/profile.d/nix.sh"