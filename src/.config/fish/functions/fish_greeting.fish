# This overwrites the welcome message shown on session init
function fish_greeting
    set GREETINGS "Само спокойно!"
    set -a GREETINGS "DON'T PANIC!"
    set -a GREETINGS "Не панікуй!"
    set -a GREETINGS "Астанавитесь!"
    set -a GREETINGS "Få inte panik!"
    set -a GREETINGS "Knock knock"
    set -a GREETINGS "Look at how fast this was!"

    printf (set_color red)"%s\n" (random choice $GREETINGS) (set_color normal)
end