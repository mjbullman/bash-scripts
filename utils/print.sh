#! /usr/bin/env bash

RED_TEXT="\033[1;91m"      # Bright Red (Material Red 500)
GREEN_TEXT="\033[1;92m"    # Bright Green (Material Green 500)
YELLOW_TEXT="\033[1;93m"   # Bright Yellow (Material Amber 500)
BLUE_TEXT="\033[1;94m"     # Bright Blue (Material Blue 500)
MAGENTA_TEXT="\033[1;95m"  # Bright Magenta (Material Pink 500)
CYAN_TEXT="\033[1;96m"     # Bright Cyan (Material Teal 500)
GRAY_TEXT="\033[1;90m"     # Bright Gray (for muted text)
RESET_TEXT="\033[0m"

function print_install_message() {
    printf "${BLUE_TEXT}🛠 Installing: %s ${RESET_TEXT}\n" "$1"
}

function print_update_message() {
    printf "${BLUE_TEXT}🔄 Updating: %s ${RESET_TEXT}\n" "$1"
}

function print_success() {
    printf "${GREEN_TEXT}✅ %s${RESET_TEXT}\n" "$1"
}

function print_error() {
    printf "${RED_TEXT}❌ %s${RESET_TEXT}\n" "$1"
}

function print_warning() {
    printf "${YELLOW_TEXT}⚠️ %s${RESET_TEXT}\n" "$1"
}

function print_info() {
    printf "${BLUE_TEXT}ℹ️ %s${RESET_TEXT}\n" "$1"
}

function print_section() {
    local message="$1"
    local char="${2:--}"
    local width="${3:-60}"

    echo
    printf "${CYAN_TEXT} %s${RESET_TEXT}\n" "$message"
    printf "${CYAN_TEXT}%${width}s${RESET_TEXT}\n" | tr ' ' "$char"
}

function print_banner() {
    local message="$1"
    local char="${2:--}"
    local width="${3:-60}"

    echo
    printf "${BLUE_TEXT}%${width}s${RESET_TEXT}\n" | tr ' ' "$char"
    printf "${BLUE_TEXT} %s${RESET_TEXT}\n" "$message"
    printf "${BLUE_TEXT}%${width}s${RESET_TEXT}\n" | tr ' ' "$char"
}
