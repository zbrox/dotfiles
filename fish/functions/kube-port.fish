function kube-port --argument service --argument ports --description "Shorter kubectl port-forward"
    set -l ports (string split ' ' $ports)
    kubectl port-forward "service/$service" $ports --address (lan-ip)
end
