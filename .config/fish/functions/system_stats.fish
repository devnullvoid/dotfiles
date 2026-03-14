function system_stats
    echo ""
    set_color -o blue
    echo "📊 Current System Status:"
    set_color normal

    function _stat_color
        if test $argv[1] -ge 90
            set_color red
        else if test $argv[1] -ge 70
            set_color yellow
        else
            set_color green
        end
    end

    set -l current_time (date +%H:%M:%S)
    set -l uptime_pretty (uptime -p 2>/dev/null; or uptime | awk -F'( |,|:)+' '{print $6"h "$7"m"}')
    set -l uptime_raw (uptime)
    set -l users (echo $uptime_raw | sed 's/.*\([0-9]\+\) user[s]*,.*/\1/')
    set -l load_averages (echo $uptime_raw | awk -F'load average[s]?: ' '{print $2}')
    set -l kernel_ver (uname -r)
    set -l local_ip (ip addr show | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | cut -d/ -f1 | head -n 1)

    echo -n "  📅 "
    set_color cyan
    echo -n (date '+%A, %B %d, %Y')
    set_color normal
    echo -n "   🕒 Time: "
    set_color yellow
    echo $current_time
    set_color normal

    echo -n "  👥 Users: "
    set_color blue
    echo -n $users
    set_color normal
    echo -n "   🐧 Kernel: "
    set_color magenta
    echo -n $kernel_ver
    set_color normal
    echo -n "   🌐 IP: "
    set_color cyan
    echo $local_ip
    set_color normal

    echo -n "  📈 Uptime: "
    set_color green
    echo $uptime_pretty
    set_color normal

    echo -n "  ⚡ Load: "
    set_color magenta
    echo $load_averages
    set_color normal

    set -l mem_info (free -h | grep Mem:)
    set -l mem_total (echo $mem_info | awk '{print $2}')
    set -l mem_used (echo $mem_info | awk '{print $3}')
    set -l mem_percent (free | grep Mem: | awk '{printf "%.0f", $3/$2 * 100}')

    echo -n "  💾 Memory: "
    _stat_color $mem_percent
    echo "$mem_used/$mem_total ($mem_percent%)"
    set_color normal

    set -l swap_info (free -h | grep Swap:)
    set -l swap_total_raw (free | grep Swap: | awk '{print $2}')

    if test -n "$swap_total_raw" -a "$swap_total_raw" -gt 0
        set -l swap_total (echo $swap_info | awk '{print $2}')
        set -l swap_used (echo $swap_info | awk '{print $3}')
        set -l swap_percent (free | grep Swap: | awk '{printf "%.0f", $3/$2 * 100}')
        echo -n "  🔄 Swap: "
        _stat_color $swap_percent
        echo "$swap_used/$swap_total ($swap_percent%)"
        set_color normal
    end

    set -l disk_info (df -h $HOME | tail -1)
    set -l disk_used (echo $disk_info | awk '{print $3}')
    set -l disk_total (echo $disk_info | awk '{print $2}')
    set -l disk_percent (echo $disk_info | awk '{print $5}' | tr -d '%')

    echo -n "  💿 Disk: "
    _stat_color $disk_percent
    echo "$disk_used/$disk_total ($disk_percent%)"
    set_color normal

    if test -d /sys/class/power_supply/BAT0; or test -d /sys/class/power_supply/BAT1
        set -l bat_capacity (cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)
        set -l bat_status (cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1)
        if test -n "$bat_capacity"
            echo -n "  🔋 Battery: "
            if test "$bat_status" = Charging
                set_color green
            else
                _stat_color (math "100 - $bat_capacity")
            end
            echo "$bat_capacity% ($bat_status)"
            set_color normal
        end
    end

    set -l ssh_sessions (ss -tnH state established 'sport = :22' 2>/dev/null | wc -l)
    if test $ssh_sessions -gt 0
        echo -n "  🔒 SSH sessions: "
        set_color red
        echo "$ssh_sessions active"
        set_color normal
    end
    echo ""
    functions -e _stat_color
end
