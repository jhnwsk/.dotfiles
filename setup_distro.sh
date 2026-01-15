#!/bin/bash
# setup_distro.sh - Distro detection and package manager abstraction

# Global variables set by detect_distro()
DISTRO=""           # "ubuntu", "arch", "unknown"
PKG_MANAGER=""      # "apt", "pacman"
AUR_HELPER=""       # "yay", "paru", "" (empty if none)
DESKTOP_ENV=""      # "gnome", "hyprland", "kde", "unknown"

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian|pop|linuxmint)
                DISTRO="ubuntu"
                PKG_MANAGER="apt"
                ;;
            arch|cachyos|manjaro|endeavouros|garuda)
                DISTRO="arch"
                PKG_MANAGER="pacman"
                detect_aur_helper
                ;;
            *)
                DISTRO="unknown"
                echo "WARNING: Unknown distro '$ID'. Some features may not work."
                ;;
        esac
    else
        DISTRO="unknown"
        echo "WARNING: Cannot detect distro. /etc/os-release not found."
    fi

    detect_desktop_env

    echo "Detected: DISTRO=$DISTRO, PKG_MANAGER=$PKG_MANAGER, AUR_HELPER=$AUR_HELPER, DESKTOP_ENV=$DESKTOP_ENV"
}

detect_aur_helper() {
    if command -v yay &>/dev/null; then
        AUR_HELPER="yay"
    elif command -v paru &>/dev/null; then
        AUR_HELPER="paru"
    else
        AUR_HELPER=""
        echo "WARNING: No AUR helper found. Install yay or paru for full functionality."
    fi
}

detect_desktop_env() {
    # Check XDG_CURRENT_DESKTOP first (most reliable)
    case "${XDG_CURRENT_DESKTOP,,}" in
        *gnome*)    DESKTOP_ENV="gnome" ;;
        *hyprland*) DESKTOP_ENV="hyprland" ;;
        *kde*|*plasma*) DESKTOP_ENV="kde" ;;
        *)
            # Fallback: check running processes
            if pgrep -x "gnome-shell" &>/dev/null; then
                DESKTOP_ENV="gnome"
            elif pgrep -x "Hyprland" &>/dev/null; then
                DESKTOP_ENV="hyprland"
            else
                DESKTOP_ENV="unknown"
            fi
            ;;
    esac
}

# =============================================================================
# PACKAGE MANAGER WRAPPERS
# =============================================================================

# pkg_update - Update package lists
pkg_update() {
    case "$PKG_MANAGER" in
        apt)    sudo apt-get update -y ;;
        pacman) sudo pacman -Sy ;;
    esac
}

# pkg_upgrade - Upgrade all packages
pkg_upgrade() {
    case "$PKG_MANAGER" in
        apt)    sudo apt-get upgrade -y ;;
        pacman) sudo pacman -Syu --noconfirm ;;
    esac
}

# pkg_install - Install packages (handles name translation)
# Usage: pkg_install <package_key>...
pkg_install() {
    local packages=()
    for key in "$@"; do
        local pkg=$(get_package_name "$key")
        if [ -n "$pkg" ]; then
            packages+=("$pkg")
        fi
    done

    if [ ${#packages[@]} -eq 0 ]; then
        return 0
    fi

    case "$PKG_MANAGER" in
        apt)    sudo apt-get install -y "${packages[@]}" ;;
        pacman) sudo pacman -S --noconfirm --needed "${packages[@]}" ;;
    esac
}

# aur_install - Install from AUR (Arch only)
# Usage: aur_install <package_name>...
aur_install() {
    if [ "$DISTRO" != "arch" ]; then
        echo "WARNING: AUR install skipped (not Arch)"
        return 0
    fi

    if [ -z "$AUR_HELPER" ]; then
        echo "WARNING: No AUR helper available. Skipping: $*"
        return 1
    fi

    "$AUR_HELPER" -S --noconfirm --needed "$@"
}

# snap_or_alt - Install snap on Ubuntu, alternative on Arch
# Usage: snap_or_alt <snap_name> <snap_flags> <arch_package> <arch_source>
# arch_source: "pacman", "aur", "flatpak"
snap_or_alt() {
    local snap_name="$1"
    local snap_flags="$2"
    local arch_pkg="$3"
    local arch_source="$4"

    case "$DISTRO" in
        ubuntu)
            sudo snap install "$snap_name" $snap_flags
            ;;
        arch)
            case "$arch_source" in
                pacman)  sudo pacman -S --noconfirm --needed "$arch_pkg" ;;
                aur)     aur_install "$arch_pkg" ;;
                flatpak) flatpak install -y flathub "$arch_pkg" ;;
            esac
            ;;
    esac
}
