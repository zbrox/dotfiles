# Git flow related (some not strictly an alias but hey)
# This requires the git flow git plugin

function dorelease --description "Helper for making releases git-flow style"
    set -l BRANCH (git symbolic-ref HEAD | cut -d'/' -f3)
    if string match "$BRANCH" "release"
        set -l VERSION (git symbolic-ref HEAD | cut -d'/' -f4)
        git flow release finish "$VERSION"
    else
        set -l VERSION $argv[1]
        if test -z "$VERSION"
            echo "No version was specified"
        else
            git flow release start $VERSION
        end
    end
end
