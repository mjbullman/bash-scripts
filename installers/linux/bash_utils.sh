#! /usr/bin/env bash

source ../../utils/print.sh

function check_package_installed() {
    dpkg -l | grep -q "$1"
}

function package_version() {
    apt list --installed | grep "$1"
}

function update_system() {
    sudo apt-get update && sudo apt-get upgrade && sudo apt-get autoremove
}

function install_packages() {
    local packages=("$@")
        
    for package in "${packages[@]}"; do
                
        if check_package_installed "$package" > /dev/null; then
            print_info "$package is already installed, skipping..."
        else
            print_install_message "$package"
            
            if sudo apt install "$package" > /dev/null 2>&1; then
                print_success "$package installed successfully!"
            else
                print_error "Failed to install $package"
            fi
        fi
        echo
    done
}

function install_package_category() {
    local category_name="$1"
    local packages=("${@:2}")
    
    print_section "Installing $category_name"
    install_packages "${packages[@]}"
}
