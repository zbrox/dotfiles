# source: https://github.com/razzius/fish-functions/blob/master/functions/file-exists.fish
# small utility alias function

function file-exists --argument file
    test -e $file
end