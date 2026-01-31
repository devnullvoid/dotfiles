test ! -e "$HOME/.x-cmd.root/local/data/fish/rc.fish" || source "$HOME/.x-cmd.root/local/data/fish/rc.fish" # boot up x-cmd.

# Ensure ~/.local/bin comes first in PATH (after fnm initialization in conf.d)
fish_add_path --move --prepend ~/.local/bin

# We are using -S to ensure the scope is correct
# if test -z "$HOMEBREW_PREFIX"
#   if test -e /home/linuxbrew/.linuxbrew/bin/brew
#     eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
#   end
# end

if status is-interactive
    starship init fish | source
    enable_transience

    # Custom greeting function
    function fish_greeting
        # Call our time-based greeting function
        time_based_greeting
        # Show system stats
        system_stats
    end

    # Time-based greeting function
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

    # System stats function - comprehensive but clean
    function system_stats
        echo ""
        set_color -o blue
        echo "📊 Current System Status:"
        set_color normal

        # Helper for dynamic colors (green < 70, yellow < 90, red >= 90)
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

        # Current date and time
        echo -n "  📅 "
        set_color cyan
        echo -n (date '+%A, %B %d, %Y')
        set_color normal
        echo -n "   🕒 Time: "
        set_color yellow
        echo $current_time
        set_color normal

        # System Info - Row 1 (Users, Kernel, IP)
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

        # System Info - Row 2 (Uptime)
        echo -n "  📈 Uptime: "
        set_color green
        echo $uptime_pretty
        set_color normal

        # System Info - Row 3 (Load)
        echo -n "  ⚡ Load: "
        set_color magenta
        echo $load_averages
        set_color normal

        # Memory usage (using free command)
        set -l mem_info (free -h | grep Mem:)
        set -l mem_total (echo $mem_info | awk '{print $2}')
        set -l mem_used (echo $mem_info | awk '{print $3}')
        set -l mem_percent (free | grep Mem: | awk '{printf "%.0f", $3/$2 * 100}')

        echo -n "  💾 Memory: "
        _stat_color $mem_percent
        echo "$mem_used/$mem_total ($mem_percent%)"
        set_color normal

        # Swap usage
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

        # Disk usage for home directory
        set -l disk_info (df -h $HOME | tail -1)
        set -l disk_used (echo $disk_info | awk '{print $3}')
        set -l disk_total (echo $disk_info | awk '{print $2}')
        set -l disk_percent (echo $disk_info | awk '{print $5}' | tr -d '%')

        echo -n "  💿 Disk: "
        _stat_color $disk_percent
        echo "$disk_used/$disk_total ($disk_percent%)"
        set_color normal

        # Battery Status (Linux only - usually /sys/class/power_supply)
        if test -d /sys/class/power_supply/BAT0; or test -d /sys/class/power_supply/BAT1
            set -l bat_capacity (cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)
            set -l bat_status (cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1)
            if test -n "$bat_capacity"
                echo -n "  🔋 Battery: "
                if test "$bat_status" = Charging
                    set_color green
                else
                    _stat_color (math "100 - $bat_capacity") # Inverse logic for discharge: low is bad (red)
                end
                echo "$bat_capacity% ($bat_status)"
                set_color normal
            end
        end

        # SSH sessions - useful for security awareness
        set -l ssh_sessions (ss -tnH state established 'sport = :22' 2>/dev/null | wc -l)
        if test $ssh_sessions -gt 0
            echo -n "  🔒 SSH sessions: "
            set_color red
            echo "$ssh_sessions active"
            set_color normal
        end
        echo ""
        functions -e _stat_color # Clean up helper
    end

    # include generic colourizer config for fish
    source /etc/grc.fish

    # set vivid LS_COLORS theme to catppuccin-mocha
    set -gx LS_COLORS (vivid generate catppuccin-mocha)

    #set -g BAT_THEME Dracula
    # Commands to run in interactive sessions can go here
    #set ayu_variant mirage
    # set -a fish_complete_path ~/.local/share/fish/vendor_completions.d
    # if test -n "$HOMEBREW_PREFIX"
    # set -ag fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    # scheme set catppuccin
    # fish_config theme save "Catppuccin Frappe"
    # fish_config theme save "Catppuccin Latte"
    # fish_config theme save "Catppuccin Macchiato"
    # fish_config theme save "Catppuccin Mocha"

    pay-respects fish | source
    set -gx _PR_PACKAGE_MANAGER paru
    tv init fish | source
    set -x EXA_STANDARD_OPTIONS --long -aa --group --header --icons
    alias lsa="exa --icons -a"
    alias ls=lsd
    # alias bat="bat --theme="
    alias cat=bat
    alias vim=nvim
    alias ai=aichat
    set -x EDITOR nvim

    # intelli-shell init fish | source
    source /home/jon/.config/fish/config_secrets.fish

    # Git aliases
    alias g=git
    alias ga="git add"
    alias gaa="git add --all"
    alias gb="git branch"
    alias gba="git branch -a"
    alias gbd="git branch -d"
    alias gc="git commit -v"
    alias gcm="git commit -m"
    alias gca="git commit -a -m"
    alias gcam="git commit -a -m"
    alias gco="git checkout"
    alias gcb="git checkout -b"
    alias gd="git diff"
    alias gds="git diff --staged"
    alias gf="git fetch"
    alias gl="git pull"
    alias glog="git log --oneline --decorate --graph"
    alias gloga="git log --oneline --decorate --graph --all"
    alias gp="git push"
    alias gpo="git push origin"
    alias gpom="git push origin main"
    alias gpsup="git push --set-upstream origin (git branch --show-current)"
    alias gr="git remote"
    alias grv="git remote -v"
    alias gs="git status"
    alias gss="git status -s"
    alias gst="git stash"
    alias gstp="git stash pop"
    alias gstl="git stash list"
    alias gm="git merge"
    alias grb="git rebase"
    alias grbi="git rebase -i"
    alias grbc="git rebase --continue"
    alias grba="git rebase --abort"
    # set -x FZF_DEFAULT_OPTS "--color=fg:#f8f8f2,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"
    set -x fzf_preview_dir_cmd exa --all --color=always --icons
    # set -x BAT_THEME Catppuccin-mocha
    set -x SKIM_DEFAULT_OPTIONS $SKIM_DEFAULT_OPTIONS "--color=fg:#cdd6f4,bg:#1e1e2e,matched:#313244,matched_bg:#f2cdcd,current:#cdd6f4,current_bg:#45475a,current_match:#1e1e2e,current_match_bg:#f5e0dc,spinner:#a6e3a1,info:#cba6f7,prompt:#89b4fa,cursor:#f38ba8,selected:#eba0ac,header:#94e2d5,border:#6c7086"

    # bemenu Mocha
    set -x BEMENU_OPTS '--fb "#1e1e2e" --ff "#cdd6f4" --nb "#1e1e2e" --nf "#cdd6f4" --tb "#1e1e2e" --hb "#1e1e2e" --tf "#f38ba8" --hf "#f9e2af" --af "#cdd6f4" --ab "#1e1e2e"'

    # neovim avante agent mode
    alias avante='nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'

    # qmlfmt == qmlformat
    alias qmlfmt='qmlformat'
    # alias qmlfmt='qmlformat --indent-size 4 --use-spaces --no-preserve-inline-whitespace --align-attributes --remove-extra-blank-lines --place-braces-on-new-line'

    # dms debug
    alias dmsdebug='QS_FORCE_STDERR_LOGGING=1 DMS_LOG_LEVEL=debug ~/.config/quickshell/dms/core/bin/dms run'

    # carapace --list | awk '{print $1}' | xargs -I{} carapace {} fish | source
    carapace carapace fish | source
    # thefuck --alias | source
    zoxide init fish | source
    atuin init fish | source
    # bind up _atuin_bind_up

    # gac for yadm
    function ygac
        set -l oldpwd (pwd)
        cd $HOME/.local/share/yadm/repo.git
        gac $argv
        set -l status_code $status
        cd $oldpwd
        return $status_code
    end

    # Cheat Shell without having to install it
    # function cheat
    #     for arg in $argv
    #         curl "https://cht.sh/$arg"
    #     end
    # end

    # end
    # if test "$TERM" = "xterm-kitty"
    #     # Prefer kitty kitten ssh once the host key is known so interactive prompts stay responsive
    #     function ssh --wraps=ssh --description 'Use kitty ssh when safe to do so'
    #         set -l host (ssh -G $argv 2>/dev/null | string match -rg '^hostname (.+)$')
    #         if test -n "$host"
    #             ssh-keygen -F $host >/dev/null 2>&1
    #             if test $status -eq 0
    #                 kitty +kitten ssh -- $argv
    #                 return
    #             end
    #         end
    #         command ssh $argv
    #     end
    # end
    # test -f ~/.inshellisense/fish/init.fish && source ~/.inshellisense/fish/init.fish

    # Override terminal title to show current directory instead of "qterm"
    function fish_title
        # Show current directory name, or "fish" if in home
        set -l pwd_name (basename (prompt_pwd))
        echo "$pwd_name"
        # if test "$pwd_name" = "~"
        #     echo fish
        # else
        #     echo "$pwd_name"
        # end
    end
end

#autorestic completion fish | source
#op completion fish | source

# function ssh
#   set ps_res (ps -p (ps -p %self -o ppid= | xargs) -o comm=)
#   # if [ "$ps_res" = "tmux" ]
#   if set -q TMUX
#     tmux rename-window (echo $argv | cut -d . -f 1)
#     command ssh "$argv"
#     tmux set-window-option automatic-rename "on" 1>/dev/null
#   else
#     command ssh "$argv"
#   end
# end

# function _babelfish_source -S
#   if test "$argv[1]" = '-' || string match -q '*.fish' "$argv[1]" || test -z "$argv[1]"
#     builtin source $argv
#   else
#     babelfish < $argv[1] | builtin source
#   end
# end
#
# function source -S
#   _babelfish_source $argv
# end
#
# function . -S
#   _babelfish_source $argv
# end

# source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

# retrieve command cheat sheets from cheat.sh
# fish version by @tobiasreischmann
function cheat
    curl cheat.sh/$argv
end
# register completions (on-the-fly, non-cached
# because the actual command won't be cached anyway
complete -c cheat -xa '(curl -s cheat.sh/:list)'

# bun
# set --export BUN_INSTALL "$HOME/.bun"
# set --export PATH $BUN_INSTALL/bin $PATH
alias claude-aur='/usr/bin/claude'
source "$HOME/.cargo/env.fish"

# sccache configuration
set -x RUSTC_WRAPPER ~/.cargo/bin/sccache
set -x SCCACHE_DIR ~/.cache/sccache
set -x SCCACHE_CACHE_SIZE "10G"

# Ensure ~/.local/bin is in PATH (but don't move it if already present)
fish_add_path --prepend ~/.local/bin

# Go build optimizations
set -gx GOCACHE ~/.cache/go-build
set -gx GOMODCACHE ~/.cache/go-mod

# Move system paths to end of PATH
set -l system_paths /usr/bin /usr/local/sbin /usr/local/bin /usr/sbin /sbin /bin
for p in $system_paths
    set -g PATH (string match -v $p $PATH)
end
set -gx PATH $PATH $system_paths
