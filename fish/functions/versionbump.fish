# Git flow related (some not strictly an alias but hey)
# This requires the git flow git plugin

function versionbump --description "Create a commit when just incrementing versions on a release/ branch"
    set -l VERSION (git symbolic-ref HEAD | cut -d'/' -f4)

    if test -z $VERSION
        echo "You're not on a version branch"
        return 1
    end

    git commit -m "chore: Bump up version number to $VERSION"
end
