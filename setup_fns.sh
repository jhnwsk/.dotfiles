#!/bin/bash

ask_user() {
    read -p "┃ ? (Y/n): " choice
    case "$choice" in
        n|N ) return 1;;
        * ) return 0;;
    esac
}

begin() {
    dialog --title " $1 " --infobox "\n$2\n" 5 60
    sleep 0.5
}

finished() {
    dialog --title " Done " --infobox "\n✓ $1\n" 5 60
    sleep 0.3
}
