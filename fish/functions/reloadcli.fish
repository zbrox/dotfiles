function reloadcli --description "Reloads config.fish and conf.d files"
    source $HOME/.config/fish/config.fish
    for i in $HOME/.config/fish/conf.d/*.fish
        source $i
    end
end