# Thanks again, Pascal https://github.com/killercup/pascastle/blob/master/home/.config/fish/conf.d/shortcuts.fish

# replacement of common tools
abbr -a ls 'exa'
abbr -a cat 'bat'

# pretty list
abbr -a l 'exa --all --long --modified --group --header --color-scale'

# navigating & such
abbr -a o 'open'
abbr -a mkdir 'mkdir -pv' # create folders along the path always
abbr -a search 'rg -i'

# git
abbr -a c 'git commit -m'
abbr -a commit 'git commit -m'
abbr -a master 'git checkout master'
abbr -a g 'gitup'
abbr -a amend 'git commit --amend --no-edit'
abbr -a msgamend 'git commit --amend -m'
abbr -a гит 'git' # keep forgetting to change keyboard layouts
abbr -a rmtag 'git tag --delete'
abbr -a push 'git push'
abbr -a pull 'git pull'

# ssh
alias copyssh 'pbcopy < $HOME/.ssh/id_rsa.pub'

# dns
alias reloaddns 'dscacheutil -flushcache; and sudo killall -HUP mDNSResponder'

# Python
alias pyactivate 'source bin/activate.fish'

# nix
alias nixos-switch 'sudo nixos-rebuild switch'
alias nixos-update 'sudo nix-channel --update'