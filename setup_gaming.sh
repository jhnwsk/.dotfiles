#!/bin/bash
# Minimal SteamMachine setup for CachyOS
# Boots directly into Steam Big Picture via gamescope

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/setup_fns.sh"
source "$SCRIPT_DIR/setup_distro.sh"

detect_distro

# Section definitions: name + description
SECTIONS=("base" "gpu" "gaming" "greetd" "fallback")
DESCRIPTIONS=(
    "audio + essentials"
    "graphics drivers"
    "steam + gamescope"
    "auto-login config"
    "hyprland desktop"
)

get_desc() {
    local section="$1"
    for i in "${!SECTIONS[@]}"; do
        if [[ "${SECTIONS[i]}" == "$section" ]]; then
            echo "${DESCRIPTIONS[i]}"
            return
        fi
    done
}

# =============================================================================
# BASE - audio + essentials
# =============================================================================

function run_base {
    begin "base" "$(get_desc base)"

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
    begin "gpu" "$(get_desc gpu)"

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
    begin "gaming" "$(get_desc gaming)"

    # CachyOS gaming meta-packages
    # - cachyos-gaming-meta: Proton, Wine, 32-bit libs, Vulkan tools, audio plugins
    # - cachyos-gaming-applications: Steam, gamescope, mangohud, gamemode, launchers
    pkg_install cachyos-gaming-meta cachyos-gaming-applications

    # Steam Deck-like session (gamescope-session)
    pkg_install cachyos-handheld

    finished "gaming (steam/gamescope/proton)"
}

# =============================================================================
# GREETD - auto-login to gamescope session
# =============================================================================

function run_greetd {
    begin "greetd" "$(get_desc greetd)"

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
command = "gamescope-session-steam"
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
    begin "fallback" "$(get_desc fallback)"

    # Minimal Hyprland for when you need to exit Steam
    pkg_install hyprland kitty waybar wofi

    # greetd-tuigreet for session selection (optional)
    pkg_install greetd-tuigreet

    dialog --msgbox "\nFallback desktop installed.\n\nTo switch between sessions:\n- Edit /etc/greetd/config.toml\n- Or install greetd-tuigreet for a menu\n" 12 50

    finished "fallback (hyprland desktop)"
}

# =============================================================================
# RUNNER
# =============================================================================

ALL_DONE="all_done"
function run_all_done {
    dialog --title " SteamMachine Ready " --msgbox "\nSetup complete!\n\nReboot to start Steam Big Picture.\n\nController should work for navigation.\n" 10 50
    clear
}

show_menu() {
    local args=()
    args+=("ALL" ">>> Full SteamMachine setup <<<" "OFF")
    for i in "${!SECTIONS[@]}"; do
        args+=("$((i+1))" "${SECTIONS[i]} - ${DESCRIPTIONS[i]}" "OFF")
    done

    local choices
    choices=$(dialog --stdout --title "SteamMachine Setup (CachyOS)" \
        --checklist "SPACE=toggle, ENTER=confirm" \
        15 60 10 \
        "${args[@]}")

    echo "$choices"
}

run_sections() {
    local indices="$1"
    if [[ "$indices" == *"ALL"* ]]; then
        for section in "${SECTIONS[@]}"; do
            function_name="run_${section}"
            $function_name
        done
        return
    fi
    for index in $indices; do
        index="${index//\"/}"
        section="${SECTIONS[index-1]}"
        function_name="run_${section}"
        $function_name
    done
}

if [ "$1" == "--all" ]; then
    for section in "${SECTIONS[@]}"; do
        function_name="run_${section}"
        $function_name
    done
elif [ "$#" -eq 0 ]; then
    selected=$(show_menu)
    if [ -n "$selected" ]; then
        run_sections "$selected"
    else
        echo "No sections selected. Exiting."
        exit 0
    fi
else
    for index in "$@"; do
        section="${SECTIONS[index-1]}"
        function_name="run_${section}"
        $function_name
    done
fi

run_all_done
