function lan-ip --description "Get your LAN IP address"
    ifconfig | grep "broadcast" | head -1 | awk '{print $2}'
end