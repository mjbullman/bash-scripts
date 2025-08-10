#! /usr/bin/env bash

cd "${HOME}/Development/JavascriptProjects/javascript-library/" || exit

SESSION="js-lib-dev"

tmux has-session -t $DEV_SESSION_NAME 2>/dev/null
if [ $? != 0 ]; then
    # Create first window with nvim
    tmux new-session -d -s $SESSION -n editor "nvim"

    # Create second window for tests
    tmux new-window -t $SESSION -n test "npm run test"

    # Create third window for linting
    tmux new-window -t $SESSION -n lint "npm run lint:watch"

    # Optional: go back to editor window
    tmux select-window -t $SESSION:0
fi

# Attach to session
tmux attach -t $SESSION
