function tag
    set -l VERSION $argv[1]
    
    if not is_version $VERSION
        echo "This doesn't seem like a x.x.x version"
        return 1
    end

    if test -z $VERSION
        echo "You hasn't specified a version"
        return 1
    end
    
    git tag -a "$VERSION" -m "$VERSION"
end

function is_version
    set -l breakdown (string split . $argv[1])

    if test (count $breakdown) -ne 3
        return 1
    end

    for i in $breakdown
        if not string match --quiet --regex '^[0-9]+$' $i
            return 1
        end
    end

    return 0
end