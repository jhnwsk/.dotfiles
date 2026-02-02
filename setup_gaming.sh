#!/bin/bash
# Minimal SteamMachine setup for CachyOS
# Boots directly into Steam Big Picture via gamescope

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/setup_fns.sh"
source "$SCRIPT_DIR/setup_distro.sh"

detect_distro

# =============================================================================
# BASE - audio + essentials
# =============================================================================

function run_base {
    begin "base" "audio + essentials"

    pkg_update
    pkg_upgrade
    pkg_install base-devel git curl dialog

    # Networking (for WiFi support in Steam)
    pkg_install networkmanager
    sudo systemctl enable --now NetworkManager

    # Audio (pipewire)
    pkg_install pipewire pipewire-pulse pipewire-alsa wireplumber

    finished "base (audio/essentials)"
}

# =============================================================================
# GPU - auto-detect and install drivers
# =============================================================================

detect_gpu() {
    if lspci | grep -qi nvidia; then
        echo "nvidia"
    elif lspci | grep -qi "amd\|radeon"; then
        echo "amd"
    elif lspci | grep -qi intel; then
        echo "intel"
    else
        echo "unknown"
    fi
}

function run_gpu {
    begin "gpu" "graphics drivers"

    local gpu_type=$(detect_gpu)

    case "$gpu_type" in
        nvidia)
            dialog --infobox "\nDetected NVIDIA GPU - installing drivers...\n" 5 50
            pkg_install nvidia nvidia-utils lib32-nvidia-utils nvidia-settings
            ;;
        amd)
            dialog --infobox "\nDetected AMD GPU - installing drivers...\n" 5 50
            pkg_install mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon
            ;;
        intel)
            dialog --infobox "\nDetected Intel GPU - installing drivers...\n" 5 50
            pkg_install mesa lib32-mesa vulkan-intel lib32-vulkan-intel
            ;;
        *)
            dialog --msgbox "\nCould not detect GPU type.\nPlease install drivers manually.\n" 8 50
            return 1
            ;;
    esac

    finished "gpu ($gpu_type drivers)"
}

# =============================================================================
# GAMING - CachyOS meta-packages
# =============================================================================

function run_gaming {
    begin "gaming" "steam + gamescope"

    # CachyOS gaming meta-packages
    # - cachyos-gaming-meta: Proton, Wine, 32-bit libs, Vulkan tools, audio plugins
    # - cachyos-gaming-applications: Steam, gamescope, mangohud, gamemode, launchers
    pkg_install cachyos-gaming-meta cachyos-gaming-applications

    # Steam Deck-like session (gamescope-session)
    pkg_install cachyos-handheld gamescope-session-git gamescope-session-steam-git

    finished "gaming (steam/gamescope/proton)"
}

# =============================================================================
# GREETD - auto-login to gamescope session
# =============================================================================

function run_greetd {
    begin "greetd" "auto-login config"

    pkg_install greetd

    # Get username for auto-login
    local current_user=$(whoami)
    local login_user=$(dialog --stdout --inputbox "Auto-login username:" 8 50 "$current_user")
    [ -z "$login_user" ] && login_user="$current_user"

    # Create greetd config for gamescope-session
    sudo tee /etc/greetd/config.toml > /dev/null <<EOF
[terminal]
vt = 1

[default_session]
command = "gamescope-session-plus steam"
user = "$login_user"
EOF

    # Disable other display managers and enable greetd
    sudo systemctl disable sddm.service 2>/dev/null
    sudo systemctl disable gdm.service 2>/dev/null
    sudo systemctl disable lightdm.service 2>/dev/null
    sudo systemctl enable greetd.service

    finished "greetd (auto-login as $login_user)"
}

# =============================================================================
# FALLBACK - minimal Hyprland desktop
# =============================================================================

function run_fallback {
    begin "fallback" "hyprland desktop"

    # Minimal Hyprland for when you need to exit Steam
    pkg_install hyprland kitty waybar wofi

    # greetd-tuigreet for session selection (optional)
    pkg_install greetd-tuigreet

    dialog --msgbox "\nFallback desktop installed.\n\nTo switch between sessions:\n- Edit /etc/greetd/config.toml\n- Or install greetd-tuigreet for a menu\n" 12 50

    finished "fallback (hyprland desktop)"
}

# =============================================================================
# MAIN
# =============================================================================

show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "SteamMachine setup - installs everything needed for a console-like experience."
    echo ""
    echo "Options:"
    echo "  --with-fallback    Unattended install with Hyprland fallback desktop"
    echo "  --no-fallback      Unattended install without fallback desktop"
    echo "  -h, --help         Show this help"
    echo ""
    echo "Without options, runs interactively and asks about fallback desktop."
}

run_core() {
    run_base
    run_gpu
    run_gaming
    run_greetd
}

show_complete() {
    dialog --title " SteamMachine Ready " --msgbox "\nSetup complete!\n\nReboot to start Steam Big Picture.\n\nController should work for navigation.\n" 10 50
    clear
}

# Parse arguments
INSTALL_FALLBACK=""

case "${1:-}" in
    --with-fallback)
        INSTALL_FALLBACK="yes"
        ;;
    --no-fallback)
        INSTALL_FALLBACK="no"
        ;;
    -h|--help)
        show_usage
        exit 0
        ;;
    "")
        # Interactive mode - will ask
        INSTALL_FALLBACK=""
        ;;
    *)
        echo "Unknown option: $1"
        show_usage
        exit 1
        ;;
esac

# Run core sections
run_core

# Handle fallback desktop
if [ -z "$INSTALL_FALLBACK" ]; then
    # Interactive: ask user
    if dialog --stdout --yesno "Install fallback desktop (Hyprland)?\n\nUseful for non-gaming tasks when you exit Steam." 9 50; then
        run_fallback
    fi
elif [ "$INSTALL_FALLBACK" = "yes" ]; then
    run_fallback
fi

show_complete
