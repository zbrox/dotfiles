# source: https://github.com/razzius/fish-functions/blob/master/functions/wifi-network-name.fish
# macOS specific

function wifi-network-name
    /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'
end