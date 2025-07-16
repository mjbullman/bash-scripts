#! /usr/bin/env bash

# source utilities.
source ../utils/print.sh
source ../utils/folders.sh

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

        if ! folder_exists "$CONFIG_DIR"; then
            mkdir "$CONFIG_DIR/ghostty"
        fi

        if ln -sf "$DOTFILES_DIR/ghostty.config" "$CONFIG_DIR/ghostty/config"; then
          print_success "starship.toml installed!"
        else
          print_error "Failed to install starship.toml!"
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
    local neovim_dir="$CONFIG_DIR/nvim/"

    if [[ -d "neovim" ]]; then
        print_banner "Installing Neovim Configuration"

        # create nvim folder if it does not exist.
        if [[ ! -d "$neovim_dir" ]]; then
          mkdir "$neovim_dir"
        fi

        if cp -r neovim/* "$neovim_dir"; then
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