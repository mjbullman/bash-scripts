#! /usr/bin/env bash

function folder_exists() {
    local folder_path="$1"

    if [ ! -d "$folder_path" ]; then
        return 1
    fi
}

function folder_empty() {
    local folder_path="$1"

    if folder_exists "$folder_path" && [ ! "$(ls -A "$folder_path")" ]; then
        return 1
    fi
}

