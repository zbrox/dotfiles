function zeropad --argument number --argument upto
    set number_length (string length $number)
    set zero_padding (string repeat -n (math $upto - $number_length) "0")

    echo "$zero_padding$number"
end