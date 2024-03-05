function whose-port --description "Check which process listens on a given port number"
    set -l PORT $argv[1]
    lsof -nP -iTCP:$PORT | grep LISTEN
end