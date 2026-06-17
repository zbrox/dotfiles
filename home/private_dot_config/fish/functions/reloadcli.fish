function reloadcli --description "Replace this shell with a fresh fish process"
    if status is-login
        exec fish -l
    else
        exec fish
    end
end
