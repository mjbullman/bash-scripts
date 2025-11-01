#!/usr/bin/env bash

# source utilities and packages.
source ../packages.shared.conf
source ../packages.macos.conf
source ./brew_utils.sh

print_banner "MacOS System Configuration"

# check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    print_warning "Homebrew not found. Installing Homebrew..."
    install_homebrew
    print_success "Homebrew installed successfully!"
fi

# update Homebrew
print_section "Updating Homebrew"
update_homebrew
print_success "Homebrew updated successfully!"

# install system utilities
if [[ -n "${SYSTEM_UTILS[@]}" ]]; then
    install_package_category "System Utilities" "${SYSTEM_UTILS[@]}"
fi

# install development tools (if defined)
if [[ -n "${NETWORKING_TOOLS[@]}" ]]; then
    install_package_category "Networking Tools" "${NETWORKING_TOOLS[@]}"
fi

# install development tools (if defined)
if [[ -n "${DEV_TOOLS[@]}" ]]; then
    install_package_category "Development Tools" "${DEV_TOOLS[@]}"
fi

# install casks (if defined)
if [[ -n "${CASKS[@]}" ]]; then
    install_package_category "Casks" "${CASKS[@]}"
fi

# # install fonts (if defined)
# if [[ -n "${FONTS[@]}" ]]; then
#     install_package_category "Fonts" "${FONTS[@]}"
# fi

print_banner "Installation Complete!"
print_info "All packages have been processed. Check the summary above for any issues."
