# source: https://github.com/razzius/fish-functions/blob/master/functions/ip-addr.fish
# fetches current public IP address

function ip-addr
    curl api.ipify.org
end