#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/setup_fns.sh"
source "$SCRIPT_DIR/setup_distro.sh"
source "$SCRIPT_DIR/setup_packages.sh"

# Detect system configuration
detect_distro

# Create arrays to hold section names and descriptions
SECTIONS=()
DESCRIPTIONS=()

# Helper to look up description by section name
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
# CORE
# =============================================================================

BASE="base"; SECTIONS+=("$BASE"); DESCRIPTIONS+=("the fundaments of awesome")
function run_base {
    begin "$BASE" "$(get_desc $BASE)"
    pkg_update
    pkg_upgrade
    # the must-haves
    pkg_install zsh htop git curl tldr direnv ncdu xclip
    # the nice-to-haves
    pkg_install build_essential libssl flatpak gparted
    # Snapd only on Ubuntu
    if [ "$DISTRO" = "ubuntu" ]; then
        sudo apt-get install -y snapd
    fi
    # Enable flathub
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    finished "base packages"
}

GIT="git"; SECTIONS+=("$GIT"); DESCRIPTIONS+=("who are you?")
function run_git {
    begin "$GIT" "$(get_desc $GIT)"
    git config --global user.email "jhnwsk@gmail.com"
    git config --global user.name "Jan Wąsak"
    git config --global core.editor "vim"
    finished "git config"
}

# =============================================================================
# TERMINAL ENVIRONMENT
# =============================================================================

SHELL_SETUP="shell"; SECTIONS+=("$SHELL_SETUP"); DESCRIPTIONS+=("because what you're really after... is ~sway~")
function run_shell {
    begin "$SHELL_SETUP" "$(get_desc $SHELL_SETUP)"
    # Nerd fonts (cross-platform)
    curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash
    getnf -i "FiraCode FiraMono"
    # Gogh terminal theme (supports GNOME Terminal, kitty, alacritty, etc.)
    if [ "$DESKTOP_ENV" = "gnome" ] || command -v kitty &> /dev/null; then
        pkg_install dconf_cli uuid_runtime
        echo "343" | bash -c "$(wget -qO- https://git.io/vQgMr)"
    else
        echo "Skipping Gogh - no supported terminal detected"
    fi
    # Zsh + antigen + starship (cross-platform)
    sudo usermod -s /usr/bin/zsh $(whoami)
    curl -L git.io/antigen > ~/.antigen.zsh
    ln -sf "$(pwd)/.antigenrc" "$HOME/.antigenrc"
    ln -sf "$(pwd)/.direnvrc" "$HOME/.direnvrc"
    ln -sf "$(pwd)/.zshrc" "$HOME/.zshrc"
    mkdir -p "$HOME/.config"
    ln -sf "$(pwd)/.config/starship.toml" "$HOME/.config/starship.toml"
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    chsh -s $(which zsh)
    finished "shell (zsh/antigen/starship/fonts)"
}

TMUX="tmux"; SECTIONS+=("$TMUX"); DESCRIPTIONS+=("terminal multiplexer")
function run_tmux {
    begin "$TMUX" "$(get_desc $TMUX)"
    snap_or_alt "tmux" "--classic" "tmux" "pacman"
    ln -sf "$(pwd)/.tmux.conf" "$HOME/.tmux.conf"
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(pwd)/.local/bin/tmux-dev" "$HOME/.local/bin/tmux-dev"
    if [ ! -d ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    else
        echo "TPM already installed, updating..."
        git -C ~/.tmux/plugins/tpm pull
    fi
    # Install TPM plugins and copy custom Tomorrow Night theme
    ~/.tmux/plugins/tpm/bin/install_plugins
    cp "$(pwd)/.config/tmux/tomorrow_night.conf" ~/.tmux/plugins/tmux/themes/catppuccin_tomorrow_night_tmux.conf
    finished "tmux"
}

NVIM="nvim"; SECTIONS+=("$NVIM"); DESCRIPTIONS+=("the one true editor")
function run_nvim {
    begin "$NVIM" "$(get_desc $NVIM)"
    snap_or_alt "nvim" "--classic" "neovim" "pacman"
    pkg_install cargo ripgrep lua luarocks
    # Backup existing nvim config
    mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null
    mv ~/.local/state/nvim ~/.local/state/nvim.bak 2>/dev/null
    mv ~/.cache/nvim ~/.cache/nvim.bak 2>/dev/null
    ln -sfn "$(pwd)/.config/astronvim_v5" "$HOME/.config/nvim"
    finished "nvim (AstroNvim)"
}

VIM="vim"; SECTIONS+=("$VIM"); DESCRIPTIONS+=("the classic")
function run_vim {
    begin "$VIM" "$(get_desc $VIM)"
    pkg_install vim
    ln -sf "$(pwd)/.vimrc" "$HOME/.vimrc"
    mkdir -p ~/.vim/autoload ~/.vim/bundle
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    finished "vim"
}

# =============================================================================
# DEV TOOLS
# =============================================================================

RUST="rust"; SECTIONS+=("$RUST"); DESCRIPTIONS+=("removing footguns while politely judging you")
function run_rust {
    begin "$RUST" "$(get_desc $RUST)"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    finished "rust"
}

PYTHON="python"; SECTIONS+=("$PYTHON"); DESCRIPTIONS+=("dead snakes")
function run_python {
    begin "$PYTHON" "$(get_desc $PYTHON)"
    # python_venv and python_dev are empty on Arch (included in python package)
    pkg_install python python_pip python_venv python_dev
    finished "python"
}

NODEJS="nodejs"; SECTIONS+=("$NODEJS"); DESCRIPTIONS+=("a sword without a hilt, careful.")
function run_nodejs {
    begin "$NODEJS" "$(get_desc $NODEJS)"
    curl -o- https://fnm.vercel.app/install | bash
    fnm install 22
    node -v
    npm -v
    finished "nodejs"
}

DOCKER="docker"; SECTIONS+=("$DOCKER"); DESCRIPTIONS+=("'agua mala', the man said, 'you whore'")
function run_docker {
    begin "$DOCKER" "$(get_desc $DOCKER)"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    echo "don't forget to..."
    echo "sudo groupadd docker; sudo usermod -aG docker $USER"
    echo "...later"
    finished "docker"
}

HARLEQUIN="harlequin"; SECTIONS+=("$HARLEQUIN"); DESCRIPTIONS+=("the gardens of love")
function run_harlequin {
    begin "$HARLEQUIN" "$(get_desc $HARLEQUIN)"
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source "$HOME/.cargo/env"
    uv tool install 'harlequin[postgres,mysql,s3]'
    finished "harlequin"
}

# =============================================================================
# DESKTOP & APPS
# =============================================================================

GRUB="grub"; SECTIONS+=("$GRUB"); DESCRIPTIONS+=("tela bootloader theme + os-prober")
function run_grub {
    begin "$GRUB" "$(get_desc $GRUB)"
    # Install Tela theme
    local tmp_dir=$(mktemp -d)
    git clone --depth 1 https://github.com/vinceliuice/grub2-themes.git "$tmp_dir"
    sudo "$tmp_dir/install.sh" -t tela
    rm -rf "$tmp_dir"
    # Install and run os-prober to detect other OSes
    pkg_install os_prober
    sudo os-prober
    # Regenerate GRUB config
    case "$DISTRO" in
        ubuntu)
            sudo update-grub
            ;;
        arch)
            sudo grub-mkconfig -o /boot/grub/grub.cfg
            ;;
    esac
    finished "grub (tela theme + os-prober)"
}

GNOME="gnome"
if [ "$DESKTOP_ENV" = "gnome" ]; then
    SECTIONS+=("$GNOME"); DESCRIPTIONS+=("diggy diggy hole!")
fi
function run_gnome {
    begin "$GNOME" "$(get_desc $GNOME)"
    # gnome_system_tools is empty on Arch (not available)
    pkg_install dconf_editor gnome_tweaks gnome_extensions gnome_system_tools
    # Load saved dconf settings
    dconf load / < dconf/dconf-24.04.ini
    finished "gnome"
}

HYPRLAND="hyprland"
if [ "$DESKTOP_ENV" = "hyprland" ]; then
    SECTIONS+=("$HYPRLAND"); DESCRIPTIONS+=("the wayland way")
fi
function run_hyprland {
    begin "$HYPRLAND" "$(get_desc $HYPRLAND)"
    case "$DISTRO" in
        arch)
            pkg_install wofi swww wl_clipboard grim slurp wlogout brightnessctl
            pkg_install hypridle hyprlock hyprlauncher nwg_displays
            aur_install matugen-bin ags-hyprpanel-git better-control-git
            ;;
        *)
            echo "Hyprland tools not configured for $DISTRO"
            ;;
    esac
    ln -sfn "$(pwd)/.config/hypr" "$HOME/.config/hypr"
    ln -sfn "$(pwd)/.config/hyprpanel" "$HOME/.config/hyprpanel"
    ln -sfn "$(pwd)/.config/wlogout" "$HOME/.config/wlogout"
    ln -sfn "$(pwd)/.config/wofi" "$HOME/.config/wofi"
    ln -sfn "$(pwd)/.config/matugen" "$HOME/.config/matugen"
    ln -sfn "$(pwd)/.config/kitty" "$HOME/.config/kitty"
    ln -sfn "$(pwd)/.config/gtk-3.0" "$HOME/.config/gtk-3.0"
    ln -sfn "$(pwd)/.config/gtk-4.0" "$HOME/.config/gtk-4.0"
    # Custom scripts
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(pwd)/.local/bin/audio-to-default" "$HOME/.local/bin/audio-to-default"
    ln -sf "$(pwd)/.local/bin/hypr-reload" "$HOME/.local/bin/hypr-reload"
    ln -sf "$(pwd)/.local/bin/monitor-toggle" "$HOME/.local/bin/monitor-toggle"
    # Set default wallpaper and generate matugen colors
    local default_wallpaper="$(pwd)/wallpapers/sea_surf_foam_2560x1600.jpg"
    if [ -f "$default_wallpaper" ]; then
        cp "$default_wallpaper" "$HOME/.config/background.jpg"
        matugen image "$HOME/.config/background.jpg"
        echo "Generated color themes from default wallpaper"
    fi
    finished "hyprland"
}

CHROME="chrome"; SECTIONS+=("$CHROME"); DESCRIPTIONS+=("because of reasons")
function run_chrome {
    begin "$CHROME" "$(get_desc $CHROME)"
    case "$DISTRO" in
        ubuntu)
            wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
            sudo apt-get install -y ./google-chrome-stable_current_amd64.deb
            rm -f google-chrome-stable_current_amd64.deb
            if [ "$DESKTOP_ENV" = "gnome" ]; then
                sudo apt-get install -y chrome-gnome-shell
            fi
            ;;
        arch)
            aur_install google-chrome
            if [ "$DESKTOP_ENV" = "gnome" ]; then
                pkg_install chrome_gnome_shell
            fi
            ;;
    esac
    finished "chrome"
}

APPS="apps"; SECTIONS+=("$APPS"); DESCRIPTIONS+=("appppppppppps!")
function run_apps {
    begin "$APPS" "$(get_desc $APPS)"
    # Terminal/CLI apps
    pkg_install yazi pwvucontrol
    ln -sfn "$(pwd)/.config/yazi" "$HOME/.config/yazi"
    # All-in-one messenger (WhatsApp, Messenger, etc.)
    pkg_install ferdium
    # Discord (vesktop for Wayland)
    if [ "$DESKTOP_ENV" = "hyprland" ]; then
        pkg_install vesktop
    else
        snap_or_alt "discord" "--classic" "discord" "pacman"
    fi
    # Signal
    snap_or_alt "signal-desktop" "" "signal-desktop" "pacman"
    # TradingView - snap on Ubuntu, flatpak on Arch
    case "$DISTRO" in
        ubuntu)
            sudo snap install tradingview --classic
            ;;
        arch)
            flatpak install -y flathub com.tradingview.tradingview || \
                echo "TradingView: Use web version or install manually from AUR"
            ;;
    esac
    # Tidal (flatpak on both)
    flatpak install -y flathub com.mastermindzh.tidal-hifi
    finished "apps"
}

SDDM="sddm"
if [ "$DISTRO" = "arch" ]; then
    SECTIONS+=("$SDDM"); DESCRIPTIONS+=("SilentSDDM theme with HiDPI")
fi
function run_sddm {
    begin "$SDDM" "$(get_desc $SDDM)"
    case "$DISTRO" in
        arch)
            aur_install sddm-silent-theme-git redhat-fonts
            ;;
        *)
            echo "SDDM theme not configured for $DISTRO"
            return
            ;;
    esac
    # Symlink main sddm.conf (HiDPI + theme selection)
    sudo ln -sf "$(pwd)/sddm/sddm.conf" /etc/sddm.conf
    # Copy theme customization to silent theme
    if [ -d /usr/share/sddm/themes/silent ]; then
        sudo cp "$(pwd)/sddm/silent-theme.conf" /usr/share/sddm/themes/silent/configs/custom.conf
        sudo cp "$HOME/.config/background" /usr/share/sddm/themes/silent/backgrounds/background.jpg 2>/dev/null || true
        sudo sed -i 's/ConfigFile=.*/ConfigFile=configs\/custom.conf/' /usr/share/sddm/themes/silent/metadata.desktop
    fi
    finished "sddm"
}

# =============================================================================
# RUNNER
# =============================================================================

ALL_DONE="all_done"
function run_all_done {
    begin "all done... bye bye."
    finished "all done"
}

show_menu() {
    # Set dark green color scheme for whiptail
    export NEWT_COLORS='
        root=white,black
        window=white,black
        border=green,black
        shadow=black,black
        title=green,black
        button=black,green
        actbutton=white,green
        checkbox=white,black
        actcheckbox=black,green
        compactbutton=white,black
        entry=white,black
        label=white,black
        listbox=white,black
        actlistbox=black,green
        sellistbox=white,green
        actsellistbox=black,green
        textbox=white,black
        acttextbox=black,green
        helpline=black,green
        roottext=white,black
        emptyscale=,black
        fullscale=white,green
        disentry=gray,black
    '

    # Build the checklist arguments with ALL option first
    local args=()
    args+=("ALL" ">>> Install everything <<<" "OFF")
    for i in "${!SECTIONS[@]}"; do
        args+=("$((i+1))" "${SECTIONS[i]} - ${DESCRIPTIONS[i]}" "OFF")
    done

    # Show whiptail checklist and capture selection
    local choices
    choices=$(whiptail --title "Dotfiles Setup" \
        --checklist "SPACE=toggle, ENTER=confirm" \
        20 90 15 \
        "${args[@]}" \
        3>&1 1>&2 2>&3)

    # Return the choices (space-separated numbers in quotes)
    echo "$choices"
}

run_sections() {
    local indices="$1"
    # Check if ALL was selected
    if [[ "$indices" == *"ALL"* ]]; then
        for section in "${SECTIONS[@]}"; do
            function_name="run_${section}"
            $function_name
        done
        return
    fi
    # Remove quotes and iterate
    for index in $indices; do
        # Strip quotes from each index
        index="${index//\"/}"
        section="${SECTIONS[index-1]}"
        function_name="run_${section}"
        $function_name
    done
}

if [ "$1" == "--all" ]; then
    # Run all sections
    for section in "${SECTIONS[@]}"; do
        function_name="run_${section}"
        $function_name
    done
elif [ "$#" -eq 0 ]; then
    # Interactive mode with whiptail
    selected=$(show_menu)
    if [ -n "$selected" ]; then
        run_sections "$selected"
    else
        echo "No sections selected. Exiting."
        exit 0
    fi
else
    # Run specific sections by number
    for index in "$@"; do
        section="${SECTIONS[index-1]}"
        function_name="run_${section}"
        $function_name
    done
fi

# Always run the "all done" section last
run_all_done
