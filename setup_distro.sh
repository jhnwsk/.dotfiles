#!/bin/bash
# setup_distro.sh - Arch Linux detection and package helpers

AUR_HELPER=""

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            arch|cachyos|manjaro|endeavouros|garuda)
                detect_aur_helper
                echo "Detected: $ID (AUR_HELPER=$AUR_HELPER)"
                ;;
            *)
                echo "ERROR: Unsupported distro '$ID'. This setup is for Arch-based systems only."
                exit 1
                ;;
        esac
    else
        echo "ERROR: Cannot detect distro. /etc/os-release not found."
        exit 1
    fi
}

detect_aur_helper() {
    if command -v yay &>/dev/null; then
        AUR_HELPER="yay"
    elif command -v paru &>/dev/null; then
        AUR_HELPER="paru"
    else
        echo "WARNING: No AUR helper found. Install yay or paru for full functionality."
    fi
}

pkg_update() {
    sudo pacman -Sy
}

pkg_upgrade() {
    sudo pacman -Syu --noconfirm
}

pkg_install() {
    sudo pacman -S --noconfirm --needed "$@"
}

aur_install() {
    if [ -z "$AUR_HELPER" ]; then
        echo "WARNING: No AUR helper available. Skipping: $*"
        return 1
    fi
    "$AUR_HELPER" -S --noconfirm --needed "$@"
}
