#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Tmux Setup Script for Development and Monitoring Windows in One Session
#
# This script automates the creation of a tmux session with two windows:
#  - "development": for general usage with a split-pane layout
#  - "monitoring": for system monitoring using btop, iftop, and iotop
#
# If any of the required tools (btop, iftop, iotop) are not installed,
# the script will attempt to install them using apt.
#
# Usage:
#   ./tmux-setup_monitoring.sh
#
# Requirements:
#   - tmux
#   - sudo privileges for installing packages
#   - bash
#
# Note:
#   Use `tmux attach-session -t mysession` to connect manually.
# -----------------------------------------------------------------------------

SESSION="dev"

# ensure monitoring tools are installed.
if ! command -v btop &> /dev/null; then
    echo "Installing btop..."
    sudo apt install -y btop
fi

if ! command -v iftop &> /dev/null; then
    echo "Installing iftop..."
    sudo apt install -y iftop
fi

if ! command -v iotop &> /dev/null; then
    echo "Installing iotop..."
    sudo apt install -y iotop
fi

# start session if it doesn't exist.
if tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "Session '$SESSION' already exists!"
else
    tmux new-session -d -s "$SESSION" -n development

    # DEVELOPMENT window with split panes.
    tmux split-window -h -t "$SESSION":0
    tmux split-window -v -t "$SESSION":0.1

    # Monitor window for btop, iftop, and iotop.
    tmux new-window -t "$SESSION":1 -n monitoring
    tmux send-keys -t "$SESSION":1.0 "btop" C-m
    tmux send-keys -t "$SESSION":1.1 "sudo iftop" C-m
    tmux send-keys -t "$SESSION":1.2 "sudo iotop" C-m

    echo "Created session '$SESSION' with development and monitoring windows."
fi

# Attach to the session
tmux attach-session -t "$SESSION"

exit 0
