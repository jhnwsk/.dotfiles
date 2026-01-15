#!/bin/bash
# setup_packages.sh - Package name mappings for Ubuntu and Arch

# Declare associative arrays for package mappings
declare -A PKG_UBUNTU
declare -A PKG_ARCH

# =============================================================================
# CORE PACKAGES
# =============================================================================

PKG_UBUNTU[zsh]="zsh"
PKG_ARCH[zsh]="zsh"

PKG_UBUNTU[htop]="htop"
PKG_ARCH[htop]="htop"

PKG_UBUNTU[git]="git"
PKG_ARCH[git]="git"

PKG_UBUNTU[curl]="curl"
PKG_ARCH[curl]="curl"

PKG_UBUNTU[wget]="wget"
PKG_ARCH[wget]="wget"

PKG_UBUNTU[tldr]="tldr"
PKG_ARCH[tldr]="tldr"

PKG_UBUNTU[direnv]="direnv"
PKG_ARCH[direnv]="direnv"

PKG_UBUNTU[ncdu]="ncdu"
PKG_ARCH[ncdu]="ncdu"

PKG_UBUNTU[xclip]="xclip"
PKG_ARCH[xclip]="xclip"

# =============================================================================
# BUILD TOOLS
# =============================================================================

PKG_UBUNTU[build_essential]="build-essential"
PKG_ARCH[build_essential]="base-devel"

PKG_UBUNTU[libssl]="libssl-dev"
PKG_ARCH[libssl]="openssl"

# =============================================================================
# SYSTEM UTILITIES
# =============================================================================

PKG_UBUNTU[flatpak]="flatpak"
PKG_ARCH[flatpak]="flatpak"

PKG_UBUNTU[gparted]="gparted"
PKG_ARCH[gparted]="gparted"

# =============================================================================
# EDITORS & TOOLS
# =============================================================================

PKG_UBUNTU[vim]="vim"
PKG_ARCH[vim]="vim"

PKG_UBUNTU[cargo]="cargo"
PKG_ARCH[cargo]="rust"  # Arch: rust package includes cargo

PKG_UBUNTU[ripgrep]="ripgrep"
PKG_ARCH[ripgrep]="ripgrep"

PKG_UBUNTU[lua]="lua5.1"
PKG_ARCH[lua]="lua"

PKG_UBUNTU[luarocks]="luarocks"
PKG_ARCH[luarocks]="luarocks"

# =============================================================================
# PYTHON
# =============================================================================

PKG_UBUNTU[python]="python3"
PKG_ARCH[python]="python"

PKG_UBUNTU[python_pip]="python3-pip"
PKG_ARCH[python_pip]="python-pip"

PKG_UBUNTU[python_venv]="python3-venv"
PKG_ARCH[python_venv]=""  # Included in python package on Arch

PKG_UBUNTU[python_dev]="python3-dev"
PKG_ARCH[python_dev]=""  # Included in python package on Arch

# =============================================================================
# GNOME (some packages different or unavailable on Arch)
# =============================================================================

PKG_UBUNTU[gnome_system_tools]="gnome-system-tools"
PKG_ARCH[gnome_system_tools]=""  # Not available on Arch

PKG_UBUNTU[dconf_editor]="dconf-editor"
PKG_ARCH[dconf_editor]="dconf-editor"

PKG_UBUNTU[gnome_tweaks]="gnome-tweaks"
PKG_ARCH[gnome_tweaks]="gnome-tweaks"

PKG_UBUNTU[gnome_extensions]="gnome-shell-extensions"
PKG_ARCH[gnome_extensions]="gnome-shell-extensions"

PKG_UBUNTU[chrome_gnome_shell]="chrome-gnome-shell"
PKG_ARCH[chrome_gnome_shell]="gnome-browser-connector"

# =============================================================================
# HYPRLAND ECOSYSTEM
# =============================================================================

PKG_UBUNTU[waybar]=""  # Not typically used on Ubuntu
PKG_ARCH[waybar]="waybar"

PKG_UBUNTU[wofi]=""
PKG_ARCH[wofi]="wofi"

PKG_UBUNTU[dunst]="dunst"
PKG_ARCH[dunst]="dunst"

PKG_UBUNTU[swww]=""
PKG_ARCH[swww]="swww"

PKG_UBUNTU[wl_clipboard]=""
PKG_ARCH[wl_clipboard]="wl-clipboard"

PKG_UBUNTU[grim]=""
PKG_ARCH[grim]="grim"

PKG_UBUNTU[slurp]=""
PKG_ARCH[slurp]="slurp"

# =============================================================================
# LOOKUP FUNCTION
# =============================================================================

get_package_name() {
    local key="$1"
    case "$DISTRO" in
        ubuntu) echo "${PKG_UBUNTU[$key]}" ;;
        arch)   echo "${PKG_ARCH[$key]}" ;;
        *)      echo "${PKG_UBUNTU[$key]}" ;;  # Default to Ubuntu
    esac
}
