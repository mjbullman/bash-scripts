#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Tmux Setup Script for Development and Monitoring Sessions
#
# This script automates the creation of two tmux sessions:
#  - "development": for general usage with a split-pane layout
#  - "stats": for system monitoring using btop, iftop, and iotop
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
#   Use `tmux attach -t default` or `tmux attach -t stats` to connect manually.
# -----------------------------------------------------------------------------

SESSION_STATS="stats"
SESSION_DEFAULT="development"

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

# start DEFAULT session with split panes.
if tmux has-session -t "$SESSION_DEFAULT" 2>/dev/null; then
    echo "Session '$SESSION_DEFAULT' already exists!"
else
    tmux new-session -d -s "$SESSION_DEFAULT" -n editor
    tmux split-window -h -t "$SESSION_DEFAULT":0
    tmux split-window -v -t "$SESSION_DEFAULT":0.1
    echo "Created session '$SESSION_DEFAULT' with splits."
fi

# start STATS session with btop, iftop, iotop.
if tmux has-session -t "$SESSION_STATS" 2>/dev/null; then
    echo "Session '$SESSION_STATS' already exists!"
else
    tmux new-session -d -s "$SESSION_STATS"
    tmux split-window -h -t "$SESSION_STATS":0
    tmux split-window -v -t "$SESSION_STATS":0.1
    tmux send-keys -t "$SESSION_STATS":0.0 "btop" C-m
    tmux send-keys -t "$SESSION_STATS":0.1 "sudo iftop" C-m
    tmux send-keys -t "$SESSION_STATS":0.2 "sudo iotop" C-m
    echo "Created session '$SESSION_STATS' with monitoring tools."
fi

# attach to the dev window when completed.
tmux attach -t stats

exit 0