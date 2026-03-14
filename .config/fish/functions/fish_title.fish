function fish_title
    set -l pwd_name (basename (prompt_pwd))
    echo "$pwd_name"
end
