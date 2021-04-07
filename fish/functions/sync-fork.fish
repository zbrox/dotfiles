function sync-fork --argument branch --description "Sync a branch (default is master) with the upstream remote"
    set -q branch[1]; or set branch "master"
    git fetch upstream
    git checkout $branch
    git rebase upstream/$branch
end