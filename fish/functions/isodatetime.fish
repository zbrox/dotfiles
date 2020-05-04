function isodatetime
    # 2020-12-12T11:13:00+01:00
    set -l TIME_OFFSET (date +%z)
    set -l TIME_OFFSET_HOUR (string sub -s 1 -l 3 "$TIME_OFFSET")
    set -l TIME_OFFSET_MIN (string sub -s 4 -l 2 "$TIME_OFFSET")
    echo (date +%Y-%m-%d\T%H:%M:%S)$TIME_OFFSET_HOUR":"$TIME_OFFSET_MIN
end