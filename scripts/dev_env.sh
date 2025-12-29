#!/usr/bin/env bash

SESSION_NAME="MJBBashScripts"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if tmux has-session -t "${SESSION_NAME}" 2>/dev/null; then
    echo "Attaching to existing session: ${SESSION_NAME}..."
    tmux attach -t "${SESSION_NAME}"
else
    echo "Creating new session: ${SESSION_NAME}..."

    # create new session and start nvim
    tmux new-session -d -s "${SESSION_NAME}" -n nvim nvim

    sleep 1
    # split nvim window horizontally (top/bottom)
    tmux split-window -v -t "${SESSION_NAME}"

    # create new window and run cluade code
    sleep 1
    tmux new-window -t "${SESSION_NAME}" claude
    
    # create new window and run lazygit
    sleep 1
    tmux new-window -t "${SESSION_NAME}" lazygit

    # focus nvim window
    tmux select-window -t "${SESSION_NAME}:nvim"

    # attache to session
    tmux attach -t "${SESSION_NAME}"
fi
