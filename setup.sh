#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/setup_fns.sh"
source "$SCRIPT_DIR/setup_distro.sh"

detect_distro

# Create arrays to hold section names and descriptions
SECTIONS=()
DESCRIPTIONS=()

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
    pkg_install zsh htop git curl tealdeer direnv ncdu xclip
    pkg_install base-devel openssl flatpak gparted
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
    chsh -s $(which zsh)
    finished "shell (zsh/antigen/starship/fonts)"
}

TMUX="tmux"; SECTIONS+=("$TMUX"); DESCRIPTIONS+=("terminal multiplexer")
function run_tmux {
    begin "$TMUX" "$(get_desc $TMUX)"
    pkg_install tmux
    ln -sf "$(pwd)/.tmux.conf" "$HOME/.tmux.conf"
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(pwd)/.local/bin/tmux-dev" "$HOME/.local/bin/tmux-dev"
    if [ ! -d ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    else
        git -C ~/.tmux/plugins/tpm pull
    fi
    ~/.tmux/plugins/tpm/bin/install_plugins
    cp "$(pwd)/.config/tmux/tomorrow_night.conf" ~/.tmux/plugins/tmux/themes/catppuccin_tomorrow_night_tmux.conf
    finished "tmux"
}

NVIM="nvim"; SECTIONS+=("$NVIM"); DESCRIPTIONS+=("the one true editor")
function run_nvim {
    begin "$NVIM" "$(get_desc $NVIM)"
    pkg_install neovim rust ripgrep lua luarocks
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
    pkg_install python python-pip
    finished "python"
}

NODEJS="nodejs"; SECTIONS+=("$NODEJS"); DESCRIPTIONS+=("a sword without a hilt, careful.")
function run_nodejs {
    begin "$NODEJS" "$(get_desc $NODEJS)"
    curl -o- https://fnm.vercel.app/install | bash
    fnm install 22
    finished "nodejs"
}

DOCKER="docker"; SECTIONS+=("$DOCKER"); DESCRIPTIONS+=("'agua mala', the man said, 'you whore'")
function run_docker {
    begin "$DOCKER" "$(get_desc $DOCKER)"
    pkg_install docker docker-compose
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
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
# DESKTOP
# =============================================================================

GRUB="grub"; SECTIONS+=("$GRUB"); DESCRIPTIONS+=("tela bootloader theme + os-prober")
function run_grub {
    begin "$GRUB" "$(get_desc $GRUB)"
    local tmp_dir=$(mktemp -d)
    git clone --depth 1 https://github.com/vinceliuice/grub2-themes.git "$tmp_dir"
    sudo "$tmp_dir/install.sh" -t tela
    rm -rf "$tmp_dir"
    pkg_install os-prober
    sudo os-prober
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    finished "grub (tela theme + os-prober)"
}

HYPRLAND="hyprland"; SECTIONS+=("$HYPRLAND"); DESCRIPTIONS+=("the wayland way")
function run_hyprland {
    begin "$HYPRLAND" "$(get_desc $HYPRLAND)"
    pkg_install waybar dunst wofi swww wl-clipboard grim slurp wlogout brightnessctl
    pkg_install hypridle hyprlock hyprlauncher nwg-displays kitty btop
    aur_install matugen-bin better-control-git
    # Config symlinks
    ln -sfn "$(pwd)/.config/hypr" "$HOME/.config/hypr"
    ln -sfn "$(pwd)/.config/waybar" "$HOME/.config/waybar"
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
    ln -sf "$(pwd)/.local/bin/bluetooth-menu" "$HOME/.local/bin/bluetooth-menu"
    ln -sf "$(pwd)/.local/bin/network-menu" "$HOME/.local/bin/network-menu"
    # Wallpaper and matugen
    mkdir -p "$HOME/.config/dunst"
    local default_wallpaper="$(pwd)/wallpapers/sea_surf_foam_2560x1600.jpg"
    if [ -f "$default_wallpaper" ]; then
        cp "$default_wallpaper" "$HOME/.config/background"
        matugen image "$default_wallpaper"
        echo "Generated color themes from default wallpaper"
    fi
    finished "hyprland"
}

CHROME="chrome"; SECTIONS+=("$CHROME"); DESCRIPTIONS+=("because of reasons")
function run_chrome {
    begin "$CHROME" "$(get_desc $CHROME)"
    aur_install google-chrome
    finished "chrome"
}

APPS="apps"; SECTIONS+=("$APPS"); DESCRIPTIONS+=("appppppppppps!")
function run_apps {
    begin "$APPS" "$(get_desc $APPS)"
    pkg_install yazi pwvucontrol vesktop ferdium-bin signal-desktop
    ln -sfn "$(pwd)/.config/yazi" "$HOME/.config/yazi"
    flatpak install -y flathub com.mastermindzh.tidal-hifi
    finished "apps"
}

SDDM="sddm"; SECTIONS+=("$SDDM"); DESCRIPTIONS+=("SilentSDDM theme with HiDPI")
function run_sddm {
    begin "$SDDM" "$(get_desc $SDDM)"
    aur_install sddm-silent-theme-git redhat-fonts
    sudo ln -sf "$(pwd)/sddm/sddm.conf" /etc/sddm.conf
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

    local args=()
    args+=("ALL" ">>> Install everything <<<" "OFF")
    for i in "${!SECTIONS[@]}"; do
        args+=("$((i+1))" "${SECTIONS[i]} - ${DESCRIPTIONS[i]}" "OFF")
    done

    local choices
    choices=$(whiptail --title "Dotfiles Setup" \
        --checklist "SPACE=toggle, ENTER=confirm" \
        20 90 15 \
        "${args[@]}" \
        3>&1 1>&2 2>&3)

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
