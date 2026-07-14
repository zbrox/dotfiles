# Direnv
eval (direnv hook fish)

# Atuin
if status is-interactive
    atuin pty-proxy init fish | source
    atuin init fish | source
end

# Fisher package manager
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# Starship prompt
starship init fish | source

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
if type -q zellij
    zellij setup --generate-completion fish | source
end

# fish vi mode
fish_vi_key_bindings

# Unset the default fish greeting text which messes up Zellij
set fish_greeting

# Check if we're in an interactive shell
if status is-interactive

    # At this point, specify the Zellij config dir, so we can launch it manually if we want to
    export ZELLIJ_CONFIG_DIR=$HOME/.config/zellij

    # Avoid auto-starting inside integrated terminals to keep session list clean
    set -l in_integrated 0
    if set -q TERM_PROGRAM
        switch (string lower -- $TERM_PROGRAM)
            case "vscode" "zed"
                set in_integrated 1
        end
    end

    if test -t 0; and not set -q ZELLIJ; and test $in_integrated -eq 0; and type -q zellij; and type -q fzf
        set -l selection (begin
            if type -q timeout
                timeout 2 zellij list-sessions 2>/dev/null
            else if type -q gtimeout
                gtimeout 2 zellij list-sessions 2>/dev/null
            else
                zellij list-sessions 2>/dev/null
            end
            echo "[new] create session"
        end | fzf --ansi --prompt "Zellij> " --header "Select a session" | string collect)
        if test -n "$selection"
            set -l clean (string replace -ra '\x1b\\[[0-9;]*m' '' -- $selection)
            set -l clean (string trim -- $clean)
            if string match -q -r '^\\[new\\]' -- $clean
                read -l -P "Create Zellij session name: " session_name
                if test -n "$session_name"
                    exec zellij --session $session_name
                end
            else
                set -l name (string split -m1 " " -- $clean)[1]
                if test -n "$name"
                    exec zellij attach $name
                end
            end
        end
    end
end
