function ygac --description "gac for yadm"
    set -l oldpwd (pwd)
    cd $HOME/.local/share/yadm/repo.git
    gac $argv
    set -l status_code $status
    cd $oldpwd
    return $status_code
end
