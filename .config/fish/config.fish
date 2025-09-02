test ! -e "$HOME/.x-cmd.root/local/data/fish/rc.fish" || source "$HOME/.x-cmd.root/local/data/fish/rc.fish" # boot up x-cmd.
# We are using -S to ensure the scope is correct
# if test -z "$HOMEBREW_PREFIX"
#   if test -e /home/linuxbrew/.linuxbrew/bin/brew
#     eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
#   end
# end

if status is-interactive
    starship init fish | source
    enable_transience

    source /etc/grc.fish
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
    tv init fish | source
    set -x EXA_STANDARD_OPTIONS --long -aa --group --header --icons
    alias ls="exa --icons -a"
    # alias bat="bat --theme="
    alias cat=bat
    alias vim=nvim
    set -x EDITOR nvim
    
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
    # zoxide init fish | source
    carapace _carapace | source
    # carapace carapace fish | source
    # thefuck --alias | source
    zoxide init fish | source
    atuin init fish | source
    bind up _atuin_bind_up
    # end
    if test "$TERM" = "xterm-kitty"
        # override ssh to use kitty +kitten ssh with proper handling for interactive prompts
        function ssh --description 'Use kitty +kitten ssh when in Kitty'
            # Use kitty kitten with explicit TTY allocation to fix interactive prompt issues
            # The -t flag forces TTY allocation which helps with host key confirmations and passwords
            kitty +kitten ssh -t $argv
        end
    end
    # test -f ~/.inshellisense/fish/init.fish && source ~/.inshellisense/fish/init.fish
    
    # Override terminal title to show current directory instead of "qterm"
    function fish_title
        # Show current directory name, or "fish" if in home
        set -l pwd_name (basename (prompt_pwd))
        if test "$pwd_name" = "~"
            echo "fish"
        else
            echo "$pwd_name"
        end
    end
end

# restic minio keys
#set -x AWS_ACCESS_KEY_ID 1ZG05zGhvCas6Lk1
#set -x AWS_SECRET_ACCESS_KEY clYakG9SFY4YAf4UyMN4i18Nq1yIZ51P

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

