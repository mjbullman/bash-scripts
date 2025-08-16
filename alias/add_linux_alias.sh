#!/usr/bin/env bash

echo "Adding aliases to .bash_aliases..."

bash_alias_file="$HOME/.bash_aliases"

# Create the bash_alias file if it does not exist.
if [ ! -f "$bash_alias_file" ]; then
    touch "$bash_alias_file"
fi

add_alias() {
    local alias_line="$1"
    local alias_name="$2"
    if ! grep -q "alias $alias_name=" "$bash_alias_file"; then
        echo "$alias_line" >> "$bash_alias_file"
        echo "Added alias: $alias_name"
    else
        echo "Alias '$alias_name' already exists."
    fi
}

# System & Package Management
add_alias "alias uu='sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt clean -y'" uu
add_alias "alias update='sudo apt update && sudo apt upgrade'" update
add_alias "alias install='sudo apt install'" install
add_alias "alias remove='sudo apt remove'" remove

# Navigation & File Management
add_alias "alias ..='cd ..'" ..
add_alias "alias ...='cd ../..'" ...
add_alias "alias ....='cd ../../..'" ....
add_alias "alias ll='ls -alF'" ll
add_alias "alias la='ls -A'" la
add_alias "alias l='ls -CF'" l
add_alias "alias cls='clear'" cls
add_alias "alias c='clear'" c

# Git Shortcuts
add_alias "alias gs='git status'" gs
add_alias "alias ga='git add'" ga
add_alias "alias gc='git commit'" gc
add_alias "alias gp='git push'" gp
add_alias "alias gl='git log --oneline --graph --decorate'" gl
add_alias "alias gco='git checkout'" gco
add_alias "alias gb='git branch'" gb

# Networking & Utilities
add_alias "alias myip='curl ifconfig.me'" myip
add_alias "alias ports='netstat -tulanp'" ports
add_alias "alias pingg='ping google.com'" pingg

# Miscellaneous
add_alias "alias h='history'" h
add_alias "alias please='sudo \\$(history -p !!)'" please
add_alias "alias serve='python3 -m http.server'" serve

# Source the aliases if the file is not empty
if [ -s "$bash_alias_file" ]; then
    # shellcheck source=/dev/null
    source "$bash_alias_file"
    echo "Aliases sourced."
fi



