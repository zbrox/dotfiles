# source: https://github.com/razzius/fish-functions/blob/master/functions/is-clean-zip.fish
# Checks if the contents of the folder has 1 root folder

function is-clean-zip --argument zipfile
    set summary (zip -sf $zipfile | string split0)
    set first_file (echo $summary | row 2 | string trim)
    set first_file_last_char (echo $first_file | string sub --start=-1)
    set n_files (echo $summary | awk NF | tail -1 | coln 2)
    test $n_files = 1 && test $first_file_last_char = /
end