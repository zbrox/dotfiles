# Shortcuts
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias reloadcli="source $HOME/.zshrc"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"

# Directories
alias dotfiles="cd $DOTFILES"
alias library="cd $HOME/Library"

# Docker
alias dockexec="docker exec -i -t"

# Xcode
alias xcodeclean="rm -frd ~/Library/Developer/Xcode/DerivedData/* && rm -frd ~/Library/Caches/com.apple.dt.Xcode/*"

# cat replacement
alias ls="exa"

# ls replacement
alias cat="bat"

# The most often used git command
alias commit="git commit -m"

# Git flow related (some not strictly an alias but hey)
# This requires the git flow git plugin
function dorelease {
    BRANCH=$(git symbolic-ref HEAD | cut -d'/' -f3)
    if [[ $BRANCH == release* ]]
    then
        VERSION=$(git symbolic-ref HEAD | cut -d'/' -f4)
        git flow release finish $VERSION
    else
        VERSION=$1
        if [ -z "$VERSION" ]
        then
            echo "No version specified"
        else
            git flow release start $VERSION
        fi
    fi
}

function versionbump {
    VERSION=$(git symbolic-ref HEAD | cut -d'/' -f4)
    git commit -m "chore: Bump up version number to $VERSION"
}
