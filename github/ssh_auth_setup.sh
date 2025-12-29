#!/usr/bin/env bash

# get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# source print functions
source "${SCRIPT_DIR}/../utils/print.sh"

print_banner "GitHub SSH Key Setup"

# set email for key
EMAIL="martin.j.bullman@pm.me"
KEY_PATH="$HOME/.ssh/id_ed25519"

# generate SSH key if it doesn't exist
if [[ -f "$KEY_PATH" ]]; then
    echo "SSH key already exists at $KEY_PATH"
else
    echo "Generating new SSH key..."
    ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_PATH" -N ""
fi

# start ssh-agent and add key
eval "$(ssh-agent -s)"
ssh-add "$KEY_PATH"

# show public key
echo
echo "Copy this SSH key to GitHub:"
echo "-----------------------------------"
cat "${KEY_PATH}.pub"
echo "-----------------------------------"
echo

# pause for user to add key to GitHub
read -p "Press Enter after you've added the key to GitHub..."

# test SSH connection
echo
echo "Testing SSH connection to GitHub..."
ssh -T git@github.com


