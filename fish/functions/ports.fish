function ports --argument name --description "Fetch commonly used ports by service name"
    switch $name
        case rabbit rabbitmq rmq
            echo 15671 15672 5672
        case cassandra
            echo 9042
        case redis
            echo 6379
        case '*'
            echo ''
    end
end