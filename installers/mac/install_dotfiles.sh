#! /usr/bin/env bash

# source utilities.
source ../../utils/print.sh
source ../../utils/folders.sh

# configuration
CONFIG_DIR="$HOME/.config"
DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_REPO="https://github.com/mjbullman/dot-files.git"

print_banner "Dot Files Installer"

function cd_dotfile_directory () {
    cd "$DOTFILES_DIR" || exit
}

function create_config_directory {
    if ! folder_exists "$CONFIG_DIR"; then
        mkdir "$CONFIG_DIR"
    fi
}

function setup_repository() {
    print_banner "Setting Up Repository"

    if [[ -d "$DOTFILES_DIR" ]]; then
        print_info "Repository already exists, updating..."

        if git pull origin main; then
            print_success "Repository updated successfully!"
        else
            print_error "Failed to update repository"
            return 1
        fi
    else
        print_info "Cloning repository..."

        if git clone "$DOTFILES_REPO" "$DOTFILES_DIR"; then
            print_success "Repository cloned successfully!"
        else
            print_error "Failed to clone repository"
            return 1
        fi
    fi
}

function install_oh_my_zsh() {
    print_banner "Installing OhMyZsh Configurations"

    local custom_plugins="$HOME/.oh-my-zsh/custom/plugins"
    local zsh_completions_path="$custom_plugins/zsh-completions"
    local zsh_autosuggestions_path="$custom_plugins/zsh-autosuggestions"
    local zsh_syntax_highlighting_path="$custom_plugins/zsh-syntax-highlighting"
    local zsh_history_search_path="$custom_plugins/zsh-history-substring-search"

    # Install Oh My Zsh (only if not already installed)
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        print_info "Oh My Zsh already installed."
    fi

    # Function to clone plugin if not already present
    clone_plugin() {
        local repo=$1
        local path=$2
        local name=$3

        if [ ! -d "$path" ]; then
            if git clone "$repo" "$path"; then
                print_success "$name Installed!"
            else
                print_error "Failed to Install $name!"
            fi
        else
            print_info "$name already installed."
        fi
    }

    clone_plugin "https://github.com/zsh-users/zsh-completions.git" "$zsh_completions_path" "ZSH Completions"
    clone_plugin "https://github.com/zsh-users/zsh-autosuggestions.git" "$zsh_autosuggestions_path" "ZSH Autosuggestions"
    clone_plugin "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$zsh_syntax_highlighting_path" "ZSH Syntax Highlighting"
    clone_plugin "https://github.com/zsh-users/zsh-history-substring-search.git" "$zsh_history_search_path" "ZSH History Search"
}

function install_zsh_configs() {
    # install .zshrc
    if [[ -f ".zshrc" ]]; then
        print_banner "Installing Zsh Configurations"

        if ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"; then
            print_success ".zshrc installed!"
        else
            print_error "Failed to install .zshrc!"
        fi
    fi

    # install .zsh_aliases
    if [[ -f ".zsh_aliases" ]]; then
        print_banner "Installing Zsh Aliases"

        if ln -sf "$DOTFILES_DIR/.zsh_aliases" "$HOME/.zsh_aliases"; then
            print_success ".zsh_aliases installed!"
        else
            print_error "Failed to install .zsh_aliases!"
        fi
    fi
}

function install_starship_config() {
    if [[ -f "starship.toml" ]]; then
        print_banner "Installing Starship Configuration"

        if ln -sf "$DOTFILES_DIR/.starship.toml" "$CONFIG_DIR/.starship.toml"; then
          print_success "starship.toml installed!"
        else
            print_error "Failed to install starship.toml!"
        fi
    fi
}

function install_ghosty_config() {
    if [[ -f "ghostty.config" ]]; then
        print_banner "Installing Ghostty Configuration"

        if ! folder_exists "$CONFIG_DIR/ghostty"; then
            mkdir "$CONFIG_DIR/ghostty"
        fi

        if ln -sf "$DOTFILES_DIR/ghostty.config" "$CONFIG_DIR/ghostty/config"; then
          print_success "ghostty.config installed!"
        else
          print_error "Failed to install ghostty.config!"
        fi
    fi
}

function install_opencode_config() {
    if [[ -f "opencode.jsonc" ]]; then
        print_banner "Installing Opencode Configuration"

        if ! folder_exists "$CONFIG_DIR/opencode"; then
            mkdir "$CONFIG_DIR/opencode"
        fi

        if ln -sf "$DOTFILES_DIR/opencode.jsonc" "$CONFIG_DIR/opencode/opencode.jsonc"; then
          print_success "opencode.jsonc installed!"
        else
          print_error "Failed to install opencode.jsonc!"
        fi
    fi
}

function install_tmux_config() {
    local tpm_dir="$HOME/.tmux/plugins/tpm"

    if [[ -f ".tmux.conf" ]]; then
        print_banner "Installing Tmux Configuration"

        if ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"; then
            print_success ".tmux.conf installed!"
        else
            print_error "Failed to install .tmux.conf!"
        fi
    fi

    # install TPM (Tmux Plugin Manager) if not already installed.
    if [[ ! -d "$tpm_dir" ]]; then
        print_banner "Installing TPM (Tmux Plugin Manager)"

        # create tpm folder if it does not exist.
        if [[ ! -d "$tpm_dir" ]]; then
            mkdir "$tpm_dir"
        fi

        if git clone https://github.com/tmux-plugins/tpm "$tpm_dir"; then
            print_success "TPM installed!"
        else
            print_error "Failed to install TPM!"
        fi
    else
        print_warning "TPM already installed!"
    fi
}

install_neovim_config() {
    if [[ -d "neovim" ]]; then
        print_banner "Installing Neovim Configuration"

        if ln -sf "$DOTFILES_DIR/neovim" "$CONFIG_DIR/nvim"; then
            print_success "Neovim configuration installed"
        else
            print_error "Failed to install Neovim configuration"
        fi
    fi
}

install_neofetch_config() {
    local neofetch_dir="$CONFIG_DIR/neofetch"

    if [[ -f "neofetch.conf" ]]; then
        print_banner "Installing NeoFetch Configuration"

        # create nefetch folder if it does not exist.
        if [[ ! -d "$neofetch_dir" ]]; then
            mkdir "$neofetch_dir"
        fi

        if ln -sf "$DOTFILES_DIR/neofetch.conf" "$neofetch_dir/neofetch.conf"; then
            print_success "neofetch.conf installed"
        else
            print_error "Failed to install neofetch.conf"
        fi
    fi
}

# main installation function.
main() {
    # check if git is installed.
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install git first."
        exit 1
    fi

    # create .config directory.
    if ! create_config_directory; then
        print_error "Could not create: $CONFIG_DIR directory."
        exit 1
    fi

    # setup repository.
    if ! setup_repository; then
        print_error "Failed to setup repository."
        exit 1
    fi

    # cd dotfiles directory.
    if ! cd_dotfile_directory; then
      print_error "Cannot access dot-files directory."
    fi

    # install configurations
    install_oh_my_zsh
    install_zsh_configs
    install_ghosty_config
    install_starship_config
    install_tmux_config
    install_neovim_config
    install_neofetch_config
    
    print_banner "Installation Complete!"
    print_success "Your dot-files have been installed successfully! 🎉"
}

# run main function
main "$@"
