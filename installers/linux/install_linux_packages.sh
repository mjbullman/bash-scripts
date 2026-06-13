#!/usr/bin/env bash

# source utilities and packages.
source ../packages.shared.conf
source ../packages.linux.conf
source ./bash_utils.sh

usage() {
    cat <<EOF
Usage: bash install_linux_packages.sh [flags]

Installs apt packages by category. With no flags, installs only
ESSENTIALS (a minimal core + linux build tools). Pass --all for
everything, or combine per-category flags.

Flags:
  --essentials     Core CLI tools + build-essential (default when no flags)
  --all            Install every category
  --shell          Shell prompt + zsh enhancements
  --tuis           Terminal TUIs (btop, lazygit, lazydocker)
  --networking     Networking utilities
  --languages      Language runtimes (go, rust, python, ...)
  --lang-tooling   Version managers and per-language tooling
  --dev            Day-to-day dev tools (git, gh, tmux, ...)
  --cloud          Cloud CLIs (aws, azure)
  --devops         Containers and queues (docker, rabbitmq)
  --db             Databases (postgresql)
  --ai             AI assistants (claude, opencode, gemini-cli)
  --fonts          Fonts
  -h, --help       Show this help and exit

Examples:
  bash install_linux_packages.sh                 # essentials only
  bash install_linux_packages.sh --all
  bash install_linux_packages.sh --essentials --dev --ai
EOF
}

INSTALL_ESSENTIALS=0
INSTALL_SHELL=0
INSTALL_TUIS=0
INSTALL_NETWORKING=0
INSTALL_LANGUAGES=0
INSTALL_LANG_TOOLING=0
INSTALL_DEV=0
INSTALL_CLOUD=0
INSTALL_DEVOPS=0
INSTALL_DB=0
INSTALL_AI=0
INSTALL_FONTS=0

if [[ $# -eq 0 ]]; then
    INSTALL_ESSENTIALS=1
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        --essentials)   INSTALL_ESSENTIALS=1 ;;
        --all)
            INSTALL_ESSENTIALS=1
            INSTALL_SHELL=1
            INSTALL_TUIS=1
            INSTALL_NETWORKING=1
            INSTALL_LANGUAGES=1
            INSTALL_LANG_TOOLING=1
            INSTALL_DEV=1
            INSTALL_CLOUD=1
            INSTALL_DEVOPS=1
            INSTALL_DB=1
            INSTALL_AI=1
            INSTALL_FONTS=1
            ;;
        --shell)        INSTALL_SHELL=1 ;;
        --tuis)         INSTALL_TUIS=1 ;;
        --networking)   INSTALL_NETWORKING=1 ;;
        --languages)    INSTALL_LANGUAGES=1 ;;
        --lang-tooling) INSTALL_LANG_TOOLING=1 ;;
        --dev)          INSTALL_DEV=1 ;;
        --cloud)        INSTALL_CLOUD=1 ;;
        --devops)       INSTALL_DEVOPS=1 ;;
        --db)           INSTALL_DB=1 ;;
        --ai)           INSTALL_AI=1 ;;
        --fonts)        INSTALL_FONTS=1 ;;
        -h|--help)      usage; exit 0 ;;
        *)              print_error "Unknown flag: $1"; usage; exit 1 ;;
    esac
    shift
done

print_banner "Linux System Configuration"

print_section "Updating System"
update_system
print_success "System updated successfully!"

if [[ $INSTALL_ESSENTIALS -eq 1 ]]; then
    install_package_category "Essentials" "${ESSENTIALS[@]}" "${ESSENTIALS_LINUX[@]}"
fi

if [[ $INSTALL_SHELL -eq 1 ]]; then
    install_package_category "Shell Enhancements" "${SHELL_ENHANCE[@]}"
fi

if [[ $INSTALL_TUIS -eq 1 ]]; then
    install_package_category "Terminal TUIs" "${TERMINAL_TUIS[@]}"
fi

if [[ $INSTALL_NETWORKING -eq 1 ]]; then
    install_package_category "Networking" "${NETWORKING[@]}"
fi

if [[ $INSTALL_LANGUAGES -eq 1 ]]; then
    install_package_category "Languages" "${LANGUAGES[@]}"
fi

if [[ $INSTALL_LANG_TOOLING -eq 1 ]]; then
    install_package_category "Language Tooling" "${LANG_TOOLING[@]}"
fi

if [[ $INSTALL_DEV -eq 1 ]]; then
    install_package_category "Dev Core" "${DEV_CORE[@]}"
fi

if [[ $INSTALL_CLOUD -eq 1 ]]; then
    install_package_category "Cloud CLIs" "${CLOUD_CLI[@]}"
fi

if [[ $INSTALL_DEVOPS -eq 1 ]]; then
    install_package_category "DevOps" "${DEVOPS[@]}"
fi

if [[ $INSTALL_DB -eq 1 ]]; then
    install_package_category "Databases" "${DATABASES[@]}"
fi

if [[ $INSTALL_AI -eq 1 ]]; then
    print_section "Installing AI CLI bootstrap installers"
    curl -fsSL https://claude.ai/install.sh | bash
    curl -fsSL https://opencode.ai/install | bash
    install_package_category "AI CLIs" "${AI_CLI[@]}"
fi

if [[ $INSTALL_FONTS -eq 1 ]]; then
    install_package_category "Fonts" "${FONTS[@]}"
fi

print_banner "Installation Complete!"
print_info "All packages have been processed. Check the summary above for any issues."
