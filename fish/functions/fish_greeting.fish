# This overwrites the welcome message shown on session init
function fish_greeting
    set -l GREETINGS "Само спокойно!"
    set -a GREETINGS "DON'T PANIC!"

    echo (random choice $GREETINGS)
end