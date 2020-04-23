# source: https://github.com/razzius/fish-functions/blob/master/functions/isodate.fish
# returns date in the ISO 8601 format without time

function isodate
    date +%Y-%m-%d
end