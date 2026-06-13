#!/usr/bin/env bash
# Unified package installer for macOS (Homebrew) and Linux (apt).
# Detects the host OS, sources the matching package configs, and installs
# categories selected via CLI flags.

set -o pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=packages.shared.conf
source "$HERE/packages.shared.conf"
# shellcheck source=pkg_utils.sh
source "$HERE/pkg_utils.sh"

if [[ "$PLATFORM" == "macos" ]]; then
    # shellcheck source=packages.macos.conf
    source "$HERE/packages.macos.conf"
    LANG_TOOLING_EXTRA=("${LANG_TOOLING_MACOS[@]}")
    ESSENTIALS_EXTRA=()
else
    # shellcheck source=packages.linux.conf
    source "$HERE/packages.linux.conf"
    LANG_TOOLING_EXTRA=()
    ESSENTIALS_EXTRA=("${ESSENTIALS_LINUX[@]}")
fi

usage() {
    cat <<EOF
Usage: bash install.sh [flags]

Installs packages by category for the detected platform ($PLATFORM).
With no flags, installs only ESSENTIALS. Pass --all for everything, or
combine per-category flags.

Flags:
  --essentials     Core CLI tools (default when no flags passed)
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
  bash install.sh                 # essentials only
  bash install.sh --all
  bash install.sh --essentials --dev --ai
EOF
}

SEL_ESSENTIALS=0; SEL_SHELL=0; SEL_TUIS=0; SEL_NETWORKING=0
SEL_LANGUAGES=0; SEL_LANG_TOOLING=0; SEL_DEV=0; SEL_CLOUD=0
SEL_DEVOPS=0; SEL_DB=0; SEL_AI=0; SEL_FONTS=0

select_all() {
    SEL_ESSENTIALS=1; SEL_SHELL=1; SEL_TUIS=1; SEL_NETWORKING=1
    SEL_LANGUAGES=1; SEL_LANG_TOOLING=1; SEL_DEV=1; SEL_CLOUD=1
    SEL_DEVOPS=1; SEL_DB=1; SEL_AI=1; SEL_FONTS=1
}

if [[ $# -eq 0 ]]; then
    SEL_ESSENTIALS=1
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        --essentials)   SEL_ESSENTIALS=1 ;;
        --shell)        SEL_SHELL=1 ;;
        --tuis)         SEL_TUIS=1 ;;
        --networking)   SEL_NETWORKING=1 ;;
        --languages)    SEL_LANGUAGES=1 ;;
        --lang-tooling) SEL_LANG_TOOLING=1 ;;
        --dev)          SEL_DEV=1 ;;
        --cloud)        SEL_CLOUD=1 ;;
        --devops)       SEL_DEVOPS=1 ;;
        --db)           SEL_DB=1 ;;
        --ai)           SEL_AI=1 ;;
        --fonts)        SEL_FONTS=1 ;;
        --all)          select_all ;;
        -h|--help)      usage; exit 0 ;;
        *)              print_error "Unknown flag: $1"; usage; exit 1 ;;
    esac
    shift
done

print_banner "$([ "$PLATFORM" = macos ] && echo "MacOS" || echo "Linux") System Configuration"

bootstrap_pkg_manager

print_section "Updating System"
update_system
print_success "System updated successfully!"

[[ $SEL_ESSENTIALS   -eq 1 ]] && install_package_category "Essentials"         "${ESSENTIALS[@]}" "${ESSENTIALS_EXTRA[@]}"
[[ $SEL_SHELL        -eq 1 ]] && install_package_category "Shell Enhancements" "${SHELL_ENHANCE[@]}"
[[ $SEL_TUIS         -eq 1 ]] && install_package_category "Terminal TUIs"      "${TERMINAL_TUIS[@]}"
[[ $SEL_NETWORKING   -eq 1 ]] && install_package_category "Networking"         "${NETWORKING[@]}"
[[ $SEL_LANGUAGES    -eq 1 ]] && install_package_category "Languages"          "${LANGUAGES[@]}"
[[ $SEL_LANG_TOOLING -eq 1 ]] && install_package_category "Language Tooling"   "${LANG_TOOLING[@]}" "${LANG_TOOLING_EXTRA[@]}"
[[ $SEL_DEV          -eq 1 ]] && install_package_category "Dev Core"           "${DEV_CORE[@]}"
[[ $SEL_CLOUD        -eq 1 ]] && install_package_category "Cloud CLIs"         "${CLOUD_CLI[@]}"
[[ $SEL_DEVOPS       -eq 1 ]] && install_package_category "DevOps"             "${DEVOPS[@]}"
[[ $SEL_DB           -eq 1 ]] && install_package_category "Databases"          "${DATABASES[@]}"
if [[ $SEL_AI -eq 1 ]]; then
    pre_install_ai
    install_package_category "AI CLIs" "${AI_CLI[@]}"
fi
[[ $SEL_FONTS -eq 1 ]] && install_package_category "Fonts" "${FONTS[@]}"

print_banner "Installation Complete!"
print_info "All packages have been processed. Check the summary above for any issues."
