# source: https://github.com/razzius/fish-functions/blob/master/functions/tar-cd.fish
# unarchive tar.gz archive and cd in the folder

function tar-cd --argument tarfile
    tar -xvzf $tarfile
    cd (echo $tarfile | trim-right '.tar.gz')
end