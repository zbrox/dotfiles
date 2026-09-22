# source: https://github.com/razzius/fish-functions/blob/master/functions/isodate.fish
# returns date in the ISO 8601 format without time

function isodate --argument short
    set -q short or set short "false"
    if test -z $short
        date +%Y-%m-%d
    else
        date +%Y%m%d
    end
end