#!/usr/bin/env bash
# Platform-aware package manager helpers. Sourced by install.sh.
# Detects the host OS and defines a unified interface:
#   - bootstrap_pkg_manager        Install/prepare the package manager
#   - update_system                Refresh package indexes / upgrade
#   - install_package_category     Install a named group of packages
#   - pre_install_shell            Hook: bootstrap shell tools not in apt
#   - pre_install_tuis             Hook: bootstrap TUI tools not in apt
#   - pre_install_lang_tooling     Hook: bootstrap lang tools not in apt
#   - pre_install_ai               Hook: bootstrap AI CLIs not in apt
#   - set_default_shell_zsh        Switch the current user's login shell to zsh
#   - hush_login                   Silence the login MOTD (Linux only; no-op on macOS)

# shellcheck source=../utils/print.sh
source "$(dirname "${BASH_SOURCE[0]}")/../utils/print.sh"

case "$(uname -s)" in
    Darwin) PLATFORM="macos" ;;
    Linux)  PLATFORM="linux" ;;
    *)      print_error "Unsupported OS: $(uname -s)"; exit 1 ;;
esac

# ---------------------------------------------------------------------------
# macOS (Homebrew)
# ---------------------------------------------------------------------------
if [[ "$PLATFORM" == "macos" ]]; then

    function bootstrap_pkg_manager() {
        if ! command -v brew &> /dev/null; then
            print_warning "Homebrew not found. Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            print_success "Homebrew installed successfully!"
        fi
    }

    function update_system()          { brew update && brew upgrade && brew cleanup; }
    function _check_installed()       { brew list | grep -q "$1"; }
    function _install_one()           { brew install "$1" > /dev/null 2>&1; }
    function pre_install_essentials()    { :; }
    function pre_install_shell()         { :; }
    function hush_login()                { :; }
    function pre_install_tuis()          { :; }
    function pre_install_lang_tooling()  { :; }
    function pre_install_ai()            { :; }

# ---------------------------------------------------------------------------
# Linux (apt)
# ---------------------------------------------------------------------------
else

    # Resolves brew formula names to their apt equivalents where they differ.
    function _linux_apt_name() {
        case "$1" in
            fd)               echo "fd-find" ;;
            python)           echo "python3" ;;
            lua)              echo "lua5.4" ;;
            noto-fonts)       echo "fonts-noto" ;;
            noto-fonts-emoji) echo "fonts-noto-color-emoji" ;;
            *)                echo "$1" ;;
        esac
    }

    function bootstrap_pkg_manager() { :; }

    function update_system() {
        sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove -y
    }

    function _check_installed() {
        case "$1" in
            neovim)     command -v nvim &>/dev/null; return ;;
            lazygit)    command -v lazygit &>/dev/null; return ;;
            lazydocker) command -v lazydocker &>/dev/null; return ;;
            uv)         command -v uv &>/dev/null; return ;;
        esac
        local apt_name
        apt_name="$(_linux_apt_name "$1")"
        dpkg -l | grep -q "$apt_name"
    }

    function _install_one() {
        case "$1" in
            neovim)     _install_neovim_from_github; return ;;
            lazygit)    _install_lazygit_from_github; return ;;
            lazydocker) _install_lazydocker_from_github; return ;;
            uv)         _install_uv; return ;;
        esac
        local apt_name
        apt_name="$(_linux_apt_name "$1")"
        sudo apt-get install -y "$apt_name" > /dev/null 2>&1
    }

    function _install_neovim_from_github() {
        local arch tarball url
        case "$(uname -m)" in
            x86_64)        arch="x86_64" ;;
            aarch64|arm64) arch="arm64" ;;
            *)             arch="x86_64" ;;
        esac
        tarball="nvim-linux-${arch}.tar.gz"
        url="https://github.com/neovim/neovim/releases/latest/download/${tarball}"
        curl -Lo "/tmp/${tarball}" "$url" > /dev/null 2>&1 \
            && sudo tar -C /usr/local --strip-components=1 -xzf "/tmp/${tarball}" \
            && rm -f "/tmp/${tarball}"
    }

    function pre_install_shell() {
        print_section "Bootstrapping: Starship"
        if command -v starship &> /dev/null; then
            print_info "starship is already installed, skipping..."
        else
            print_install_message "starship"
            if curl -sS https://starship.rs/install.sh | sh -s -- --yes > /dev/null 2>&1; then
                print_success "starship installed successfully!"
            else
                print_error "Failed to install starship"
            fi
        fi
        echo
    }

    function _install_lazygit_from_github() {
        local version arch
        version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
                  | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
        case "$(uname -m)" in
            x86_64)        arch="x86_64" ;;
            aarch64|arm64) arch="arm64" ;;
            armv*l)        arch="armv6" ;;
            *)             arch="x86_64" ;;
        esac
        curl -Lo /tmp/lazygit.tar.gz \
            "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${version}_Linux_${arch}.tar.gz" \
            > /dev/null 2>&1 \
            && tar xf /tmp/lazygit.tar.gz -C /tmp lazygit \
            && sudo install /tmp/lazygit /usr/local/bin/lazygit
        local status=$?
        rm -f /tmp/lazygit.tar.gz /tmp/lazygit
        return $status
    }

    # uv isn't reliably packaged in apt; use Astral's installer (into ~/.local/bin)
    function _install_uv() {
        curl -LsSf https://astral.sh/uv/install.sh | sh > /dev/null 2>&1
    }

    function _install_lazydocker_from_github() {
        curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash > /dev/null 2>&1
    }

    function pre_install_tuis() { :; }

    function pre_install_lang_tooling() {
        # fnm
        print_section "Bootstrapping: fnm, Rust"
        if command -v fnm &> /dev/null; then
            print_info "fnm is already installed, skipping..."
        else
            print_install_message "fnm"
            if curl -fsSL https://fnm.vercel.app/install | bash > /dev/null 2>&1; then
                print_success "fnm installed successfully!"
            else
                print_error "Failed to install fnm"
            fi
        fi
        echo

        # rustup
        if command -v rustup &> /dev/null; then
            print_info "rustup is already installed, skipping..."
        else
            print_install_message "rustup"
            if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y > /dev/null 2>&1; then
                print_success "rustup installed successfully!"
            else
                print_error "Failed to install rustup"
            fi
        fi
        echo

        # Make cargo available in this shell if rustup was just installed
        # shellcheck disable=SC1091
        [[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

        # cargo-binstall (prebuilt-binary installer for cargo crates)
        if command -v cargo-binstall &> /dev/null; then
            print_info "cargo-binstall is already installed, skipping..."
        else
            print_install_message "cargo-binstall"
            if curl -L --proto '=https' --tlsv1.2 -sSf \
                https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh \
                | bash > /dev/null 2>&1; then
                print_success "cargo-binstall installed successfully!"
            else
                print_error "Failed to install cargo-binstall"
            fi
        fi
        echo

        # tree-sitter CLI (needed by nvim-treesitter for parser builds)
        if command -v tree-sitter &> /dev/null; then
            print_info "tree-sitter is already installed, skipping..."
        elif command -v cargo-binstall &> /dev/null; then
            print_install_message "tree-sitter-cli"
            if cargo binstall -y tree-sitter-cli > /dev/null 2>&1; then
                print_success "tree-sitter-cli installed successfully!"
            else
                print_error "Failed to install tree-sitter-cli"
            fi
        else
            print_error "Skipping tree-sitter-cli: cargo-binstall not available"
        fi
        echo
    }

    function pre_install_ai() {
        print_section "Bootstrapping AI CLI installers"
        curl -fsSL https://claude.ai/install.sh | bash
        curl -fsSL https://opencode.ai/install | bash
    }

    function hush_login() {
        print_section "Suppressing login MOTD"
        if [[ -f "$HOME/.hushlogin" ]]; then
            print_info "$HOME/.hushlogin already present, skipping..."
        elif touch "$HOME/.hushlogin"; then
            print_success "Created $HOME/.hushlogin — MOTD silenced on next login"
        else
            print_error "Failed to create $HOME/.hushlogin"
        fi
    }

fi

# ---------------------------------------------------------------------------
# Shared
# ---------------------------------------------------------------------------
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

function set_default_shell_zsh() {
    print_section "Setting default shell to zsh"

    local zsh_path
    zsh_path="$(command -v zsh)"
    if [[ -z "$zsh_path" ]]; then
        print_error "zsh not found on PATH — skipping shell change"
        return
    fi

    if [[ "$SHELL" == "$zsh_path" ]]; then
        print_info "Default shell is already zsh ($zsh_path), skipping..."
        return
    fi

    if ! grep -qx "$zsh_path" /etc/shells; then
        print_info "Adding $zsh_path to /etc/shells"
        echo "$zsh_path" | sudo tee -a /etc/shells > /dev/null
    fi

    if chsh -s "$zsh_path"; then
        print_success "Default shell changed to $zsh_path (takes effect on next login)"
    else
        print_error "Failed to change default shell — run: chsh -s $zsh_path"
    fi
}
