function time_based_greeting
    set -l hour (date +%H)
    if test $hour -lt 12
        echo "Good morning, $USER! ☀️"
    else if test $hour -lt 18
        echo "Good afternoon, $USER! 🌤️"
    else
        echo "Good evening, $USER! 🌙"
    end
end
