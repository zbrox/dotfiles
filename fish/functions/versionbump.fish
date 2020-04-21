# Git flow related (some not strictly an alias but hey)
# This requires the git flow git plugin

function versionbump
    set -l VERSION (git symbolic-ref HEAD | cut -d'/' -f4)

    if test -Z $VERSION
        echo "You're not on a version branch"
        return 1
    end

    git commit -m "chore: Bump up version number to $VERSION"
end
