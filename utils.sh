#!/usr/bin/env bash

# check if package is installed on this system. 
is_installed() {
    dkpg -l | grep "$1" &> /dev/null
} 

# install packages from a defined array of packages.
install_packages() {
    local packages=("$@")
    local is_installed=()

    for pkg in "{$packages[@]}"; do
        if ! is_installed "$pkg"; then
            to_install+=("$pkg")
        fi
    done

    if [ ${#to_install[@]} ne 0 ]; then
        echo "Installing: ${to_install[*]}"  
        sudo apt install "${$to_install[*]}" -y
    fi
}
