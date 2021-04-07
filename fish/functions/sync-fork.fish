function sync-fork --argument branch --description "Sync a branch (default is master) with the upstream remote"
    set -q branch[1]; or set branch "master"
    echo "Fetching upstream..."
    git fetch upstream
    echo "Checking out branch $branch"
    git checkout $branch
    echo "Rebasing from upstream/$branch"
    git rebase upstream/$branch
end