#!/usr/bin/env bash
# Platform-aware package manager helpers. Sourced by install.sh.
# Detects the host OS and defines a unified interface:
#   - bootstrap_pkg_manager       Install/prepare the package manager
#   - update_system               Refresh package indexes / upgrade
#   - install_package_category    Install a named group of packages
#   - pre_install_ai              Hook run before the AI category (no-op on macOS)

# shellcheck source=../utils/print.sh
source "$(dirname "${BASH_SOURCE[0]}")/../utils/print.sh"

case "$(uname -s)" in
    Darwin) PLATFORM="macos" ;;
    Linux)  PLATFORM="linux" ;;
    *)      print_error "Unsupported OS: $(uname -s)"; exit 1 ;;
esac

if [[ "$PLATFORM" == "macos" ]]; then

    function bootstrap_pkg_manager() {
        if ! command -v brew &> /dev/null; then
            print_warning "Homebrew not found. Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            print_success "Homebrew installed successfully!"
        fi
    }

    function update_system() {
        brew update && brew upgrade && brew cleanup
    }

    function _check_installed() { brew list | grep -q "$1"; }
    function _install_one()     { brew install "$1" > /dev/null 2>&1; }
    function pre_install_ai()   { :; }

else

    function bootstrap_pkg_manager() { :; }

    function update_system() {
        sudo apt-get update && sudo apt-get upgrade && sudo apt-get autoremove
    }

    function _check_installed() { dpkg -l | grep -q "$1"; }
    function _install_one()     { sudo apt install -y "$1" > /dev/null 2>&1; }

    function pre_install_ai() {
        print_section "Bootstrapping AI CLI installers"
        curl -fsSL https://claude.ai/install.sh | bash
        curl -fsSL https://opencode.ai/install | bash
    }

fi

function install_package_category() {
    local category_name="$1"
    local packages=("${@:2}")

    print_section "Installing $category_name"
    for package in "${packages[@]}"; do
        if _check_installed "$package" > /dev/null; then
            print_info "$package is already installed, skipping..."
        else
            print_install_message "$package"
            if _install_one "$package"; then
                print_success "$package installed successfully!"
            else
                print_error "Failed to install $package"
            fi
        fi
        echo
    done
}
