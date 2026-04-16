test ! -e "$HOME/.x-cmd.root/local/data/fish/rc.fish" || source "$HOME/.x-cmd.root/local/data/fish/rc.fish" # boot up x-cmd.

# Ensure ~/.local/bin comes first in PATH (after fnm initialization in conf.d)
fish_add_path --move --prepend ~/.local/bin

if status is-interactive
    starship init fish | source
    enable_transience

    # include generic colourizer config for fish
    # test -f /etc/grc.fish && source /etc/grc.fish  # handled by conf.d/cgrc.fish

    # set vivid LS_COLORS theme to catppuccin-mocha
    set -gx LS_COLORS (vivid generate catppuccin-mocha)

    pay-respects fish | source
    set -gx _PR_PACKAGE_MANAGER paru
    tv init fish | source
    set -gx EDITOR nvim

    # Load secrets from sops
    source ~/.config/fish/config_secrets.fish

    # Simple command abbreviations
    alias ls=lsd
    # alias cat=bat
    abbr -a cat bat
    abbr -a uls /usr/bin/ls
    abbr -a ucat /usr/bin/cat
    abbr -a vim nvim
    abbr -a ai aichat
    abbr -a qmlfmt qmlformat
    abbr -a mdview 'glow -tl'
    abbr -a claude-aur /usr/bin/claude
    abbr -a lsa 'eza --icons -a'
    abbr -a k kiro-cli

    # Git abbreviations
    abbr -a g git
    abbr -a ga 'git add'
    abbr -a gaa 'git add --all'
    abbr -a gb 'git branch'
    abbr -a gba 'git branch -a'
    abbr -a gbd 'git branch -d'
    abbr -a gc 'git commit -v'
    abbr -a gcm 'git commit -m'
    abbr -a gca 'git commit -a -m'
    abbr -a gcam 'git commit -a -m'
    abbr -a gco 'git checkout'
    abbr -a gcb 'git checkout -b'
    abbr -a gd 'git diff'
    abbr -a gds 'git diff --staged'
    abbr -a gf 'git fetch'
    abbr -a gl 'git pull'
    abbr -a glog 'git log --oneline --decorate --graph'
    abbr -a gloga 'git log --oneline --decorate --graph --all'
    abbr -a gp 'git push'
    abbr -a gpo 'git push origin'
    abbr -a gpom 'git push origin main'
    abbr -a gr 'git remote'
    abbr -a grv 'git remote -v'
    abbr -a gs 'git status'
    abbr -a gss 'git status -s'
    abbr -a gst 'git stash'
    abbr -a gstp 'git stash pop'
    abbr -a gstl 'git stash list'
    abbr -a gm 'git merge'
    abbr -a grb 'git rebase'
    abbr -a grbi 'git rebase -i'
    abbr -a grbc 'git rebase --continue'
    abbr -a grba 'git rebase --abort'

    # These need alias/function (command substitution or env var prefix)
    alias gpsup="git push --set-upstream origin (git branch --show-current)"
    alias avante='nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'
    alias dmsdebug='QS_FORCE_STDERR_LOGGING=1 DMS_LOG_LEVEL=debug ~/.config/quickshell/dms/core/bin/dms run'

    # Fuzzy finder / theme settings
    set -gx fzf_preview_dir_cmd exa --all --color=always --icons
    set -gx SKIM_DEFAULT_OPTIONS $SKIM_DEFAULT_OPTIONS "--color=fg:#cdd6f4,bg:#1e1e2e,matched:#313244,matched_bg:#f2cdcd,current:#cdd6f4,current_bg:#45475a,current_match:#1e1e2e,current_match_bg:#f5e0dc,spinner:#a6e3a1,info:#cba6f7,prompt:#89b4fa,cursor:#f38ba8,selected:#eba0ac,header:#94e2d5,border:#6c7086"
    set -gx BEMENU_OPTS '--fb "#1e1e2e" --ff "#cdd6f4" --nb "#1e1e2e" --nf "#cdd6f4" --tb "#1e1e2e" --hb "#1e1e2e" --tf "#f38ba8" --hf "#f9e2af" --af "#cdd6f4" --ab "#1e1e2e"'

    # Shell integrations
    carapace carapace fish | source
    zoxide init fish | source
    atuin init fish | source

    # cheat.sh completions
    complete -c cheat -xa '(curl -s cheat.sh/:list)'
end

source "$HOME/.cargo/env.fish"

# sccache configuration
set -gx RUSTC_WRAPPER ~/.cargo/bin/sccache
set -gx SCCACHE_DIR ~/.cache/sccache
set -gx SCCACHE_CACHE_SIZE 10G

# Go build optimizations
set -gx GOCACHE ~/.cache/go-build
set -gx GOMODCACHE ~/.cache/go-mod

# SSH Agent
set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
