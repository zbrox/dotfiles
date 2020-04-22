# Thanks again, Pascal https://github.com/killercup/pascastle/blob/master/home/.config/fish/conf.d/shortcuts.fish

# replacement of common tools
alias ls 'exa'
alias cat 'bat'

# pretty list
alias l 'exa --all --long --modified --group --header --color-scale'

# navigating & such
abbr -a o 'open'
abbr -a mkdir 'mkdir -pv' # create folders along the path always
alias search rg -i

# git
alias c 'git commit -m'
alias commit 'git commit -m'
alias master 'git checkout master'
alias g 'gitup'
alias amend 'git commit --amend --no-edit'
alias msgamend 'git commit --amend -m'

# ssh
alias copyssh 'pbcopy < $HOME/.ssh/id_rsa.pub'

# fish reload
alias reloadcli 'source $HOME/.config/fish/config.fish; and for i in $HOME/.config/fish/conf.d/*.fish; source $i; end;'

# dns
alias reloaddns 'dscacheutil -flushcache; and sudo killall -HUP mDNSResponder'

# Xcode
alias xcodeclean 'rm -frd ~/Library/Developer/Xcode/DerivedData/*; and rm -frd ~/Library/Caches/com.apple.dt.Xcode/*'