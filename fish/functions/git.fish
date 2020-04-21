# Git flow related (some not strictly an alias but hey)
# This requires the git flow git plugin

function dorelease
    set -l BRANCH (git symbolic-ref HEAD | cut -d'/' -f3)
    if string match "$BRANCH" "release*"
        set -l VERSION (git symbolic-ref HEAD | cut -d'/' -f4)
        git flow release finish $VERSION
    else
        set -l VERSION $argv[1]
        if test -z "$VERSION"
            echo "No version was specified"
        else
            git flow release start $VERSION
        end
    end
end

function versionbump
    set -l VERSION (git symbolic-ref HEAD | cut -d'/' -f4)

    if test -Z $VERSION
        echo "You're not on a version branch"
        return 1
    end

    git commit -m "chore: Bump up version number to $VERSION"
end
