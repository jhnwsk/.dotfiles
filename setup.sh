#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/setup_fns.sh"
source "$SCRIPT_DIR/setup_distro.sh"

detect_distro

# Section definitions: name + description
SECTIONS=("core" "desktop" "terminal" "dev" "docker")
DESCRIPTIONS=(
    "the essentials"
    "hyprland environment"
    "your workspace"
    "language runtimes"
    "containerization"
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
# CORE - base + git + shell
# =============================================================================

function run_core {
    begin "core" "$(get_desc core)"

    # Base packages
    pkg_update
    pkg_upgrade
    pkg_install zsh htop git curl tealdeer direnv ncdu dialog
    pkg_install base-devel 

    # Git identity
    local current_email=$(git config --global user.email 2>/dev/null)
    local current_name=$(git config --global user.name 2>/dev/null)
    local git_email=$(dialog --stdout --inputbox "Git email:" 8 50 "$current_email")
    local git_name=$(dialog --stdout --inputbox "Git name:" 8 50 "$current_name")
    [ -n "$git_email" ] && git config --global user.email "$git_email"
    [ -n "$git_name" ] && git config --global user.name "$git_name"
    git config --global core.editor "vim"

    # Nerd fonts
    curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash
    getnf -i "FiraCode FiraMono"

    # Zsh + antigen + starship
    sudo usermod -s /usr/bin/zsh $(whoami)
    curl -L git.io/antigen > ~/.antigen.zsh
    ln -sf "$(pwd)/.antigenrc" "$HOME/.antigenrc"
    ln -sf "$(pwd)/.direnvrc" "$HOME/.direnvrc"
    ln -sf "$(pwd)/.zshrc" "$HOME/.zshrc"
    mkdir -p "$HOME/.config"
    ln -sf "$(pwd)/.config/starship.toml" "$HOME/.config/starship.toml"
    curl -sS https://starship.rs/install.sh | sh -s -- -y

    finished "core (base/git/shell)"
}

# =============================================================================
# DESKTOP - hyprland + apps + chrome + greetd
# =============================================================================

function run_desktop {
    begin "desktop" "$(get_desc desktop)"

    # Hyprland and Wayland tools
    pkg_install waybar dunst wofi swww wl-clipboard grim slurp wlogout brightnessctl
    pkg_install hypridle hyprlock nwg-displays kitty btop
    aur_install matugen-bin better-control-git

    # Config symlinks (link_dir removes existing dirs first)
    link_dir "$(pwd)/.config/hypr" "$HOME/.config/hypr"
    link_dir "$(pwd)/.config/waybar" "$HOME/.config/waybar"
    link_dir "$(pwd)/.config/wlogout" "$HOME/.config/wlogout"
    link_dir "$(pwd)/.config/wofi" "$HOME/.config/wofi"
    link_dir "$(pwd)/.config/matugen" "$HOME/.config/matugen"
    link_dir "$(pwd)/.config/kitty" "$HOME/.config/kitty"
    link_dir "$(pwd)/.config/gtk-3.0" "$HOME/.config/gtk-3.0"
    link_dir "$(pwd)/.config/gtk-4.0" "$HOME/.config/gtk-4.0"

    # Custom scripts
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(pwd)/.local/bin/audio-to-default" "$HOME/.local/bin/audio-to-default"
    ln -sf "$(pwd)/.local/bin/hypr-reload" "$HOME/.local/bin/hypr-reload"
    ln -sf "$(pwd)/.local/bin/monitor-toggle" "$HOME/.local/bin/monitor-toggle"
    ln -sf "$(pwd)/.local/bin/bluetooth-menu" "$HOME/.local/bin/bluetooth-menu"
    ln -sf "$(pwd)/.local/bin/network-menu" "$HOME/.local/bin/network-menu"

    # Wallpaper and matugen
    mkdir -p "$HOME/.config/dunst"
    local default_wallpaper="$(pwd)/wallpapers/sea_surf_foam_2560x1600.jpg"
    if [ -f "$default_wallpaper" ]; then
        ln -sf "$default_wallpaper" "$HOME/.config/background.jpg"
        matugen image "$default_wallpaper"
        echo "Generated color themes from default wallpaper"
    fi

    # Desktop apps
    pkg_install yazi pwvucontrol vesktop signal-desktop
    aur_install ferdium-bin
    link_dir "$(pwd)/.config/yazi" "$HOME/.config/yazi"

    # Chrome
    aur_install google-chrome

    # Login manager (greetd + tuigreet)
    pkg_install greetd greetd-tuigreet
    sudo ln -sf "$(pwd)/greetd/config.toml" /etc/greetd/config.toml
    sudo mkdir -p /var/cache/tuigreet
    sudo chown greeter:greeter /var/cache/tuigreet
    sudo chmod 0755 /var/cache/tuigreet
    sudo systemctl disable sddm.service 2>/dev/null
    sudo systemctl disable gdm.service 2>/dev/null
    sudo systemctl disable lightdm.service 2>/dev/null
    sudo systemctl enable greetd.service

    finished "desktop (hyprland/apps/chrome/greetd)"
}

# =============================================================================
# TERMINAL - tmux + nvim + vim
# =============================================================================

function run_terminal {
    begin "terminal" "$(get_desc terminal)"

    # Tmux
    pkg_install tmux
    ln -sf "$(pwd)/.tmux.conf" "$HOME/.tmux.conf"
    if [ ! -d ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    else
        git -C ~/.tmux/plugins/tpm pull
    fi
    ~/.tmux/plugins/tpm/bin/install_plugins
    cp "$(pwd)/.config/tmux/tomorrow_night.conf" ~/.tmux/plugins/tmux/themes/catppuccin_tomorrow_night_tmux.conf

    # Neovim (AstroNvim)
    pkg_install neovim rust ripgrep lua luarocks
    mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null
    mv ~/.local/state/nvim ~/.local/state/nvim.bak 2>/dev/null
    mv ~/.cache/nvim ~/.cache/nvim.bak 2>/dev/null
    link_dir "$(pwd)/.config/astronvim_v5" "$HOME/.config/nvim"

    # Vim
    pkg_install vim
    ln -sf "$(pwd)/.vimrc" "$HOME/.vimrc"
    mkdir -p ~/.vim/autoload ~/.vim/bundle
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

    finished "terminal (tmux/nvim/vim)"
}

# =============================================================================
# DEV - rust + python + nodejs + harlequin
# =============================================================================

function run_dev {
    begin "dev" "$(get_desc dev)"

    # Rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    # Python
    pkg_install python python-pip

    # Node.js (fnm)
    curl -o- https://fnm.vercel.app/install | bash
    fnm install 22

    # Harlequin (uv)
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source "$HOME/.cargo/env"
    uv tool install 'harlequin[postgres,mysql,s3]'

    finished "dev (rust/python/nodejs/harlequin)"
}

# =============================================================================
# DOCKER - containerization (standalone)
# =============================================================================

function run_docker {
    begin "docker" "$(get_desc docker)"
    pkg_install docker docker-compose
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
    finished "docker"
}

# =============================================================================
# RUNNER
# =============================================================================

ALL_DONE="all_done"
function run_all_done {
    dialog --title " Complete " --msgbox "\nAll done! Press Enter to exit.\n" 7 45
    clear
}

show_menu() {
    local args=()
    args+=("ALL" ">>> Install everything <<<" "OFF")
    for i in "${!SECTIONS[@]}"; do
        args+=("$((i+1))" "${SECTIONS[i]} - ${DESCRIPTIONS[i]}" "OFF")
    done

    local choices
    choices=$(dialog --stdout --title "Dotfiles Setup" \
        --checklist "SPACE=toggle, ENTER=confirm" \
        20 90 15 \
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
