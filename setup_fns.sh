#!/bin/bash

ask_user() {
    read -p "┃ ? (Y/n): " choice
    case "$choice" in
        n|N ) return 1;;
        * ) return 0;;
    esac
}

begin() {
    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "┃ $1"
    echo "┃ -----"
    echo "┃ $2"
    echo "┃"
    echo "┗-------------------------------------------------------"
    return 0
}

finished() {
    echo "┏-------------------------------------------------------"
    echo "┃ ...done with $1"
    echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

function show_help {
    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "┃ Usage: setup.sh [section ...]"
    echo "┃"
    echo "┃ Options:"
    echo "┃   --help     Show this help message"
    echo "┃"
    echo "┃ Sections:"
    echo "┃"
    for i in "${!SECTIONS[@]}"; do
        echo "┃ $((i+1)). ${SECTIONS[i]}"
    done
    echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}
