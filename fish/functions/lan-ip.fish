function lan-ip --description "Get your LAN IP address"
    ifconfig | grep "broadcast" | awk '{print $2}'
end