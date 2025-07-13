#! /usr/bin/env bash

source "../../utils/print.sh"

function check_package_installed() {
    brew list | grep -q "$1"
}

function package_version() {
    brew list --versions "$1"
}

function install_homebrew() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

function update_homebrew() {
    brew update && brew upgrade && brew cleanup
}

function install_packages() {
    local packages=("$@")
        
    for package in "${packages[@]}"; do
                
        if check_package_installed "$package" > /dev/null; then
            print_info "$package is already installed, skipping..."
        else
            print_install_message "$package"
            
            if brew install "$package" > /dev/null 2>&1; then
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