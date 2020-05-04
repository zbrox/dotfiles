function new_post
    set -l CONTENT_DIR "content/"
    set -l SLUG $argv[1]

    if test -z "$SLUG"
        echo "No post slug specified"
        return 1
    end

    if not test -d $CONTENT_DIR
        echo "No content folder, are you in a Zola project folder?"
        return 1
    end

    echo >"content/"(isodate short)"-$SLUG.md" "\
+++
title = \"\"
date = "(isodatetime)"\

slug = \"$SLUG\"
draft = true

[taxonomies]
categories = [\"general\"]
+++"
end