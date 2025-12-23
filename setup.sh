#!/bin/bash
source ./setup_fns.sh

# Create an array to hold the section names
SECTIONS=()

# =============================================================================
# CORE
# =============================================================================

BASE="base"; SECTIONS+=("$BASE")
function run_base {
    begin "$BASE" "the fundaments of awesome"
    sudo apt-get update -y
    sudo apt-get upgrade -y
    # the must-haves
    sudo apt-get install -y zsh htop git curl tldr direnv ncdu xclip
    # the nice-to-haves
    sudo apt-get install -y build-essential libssl-dev snapd flatpak gparted
    # Enable flathub
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    finished "base packages"
}

GIT="git"; SECTIONS+=("$GIT")
function run_git {
    begin "$GIT" "who are you?"
    git config --global user.email "jhnwsk@gmail.com"
    git config --global user.name "Jan Wąsak"
    git config --global core.editor "vim"
    finished "git config"
}

# =============================================================================
# TERMINAL ENVIRONMENT
# =============================================================================

SHELL_SETUP="shell"; SECTIONS+=("$SHELL_SETUP")
function run_shell {
    begin "$SHELL_SETUP" "because what you're really after... is ~sway~"
    # Nerd fonts
    curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash
    getnf -i "FiraCode FiraMono"
    # Gogh terminal theme (Tomorrow Night #252)
    echo "252" | bash -c "$(wget -qO- https://git.io/vQgMr)"
    # Zsh + antigen + starship
    sudo usermod -s /usr/bin/zsh $(whoami)
    curl -L git.io/antigen > ~/.antigen.zsh
    ln -s "$(pwd)/.antigenrc" "$HOME/.antigenrc"
    ln -s "$(pwd)/.direnvrc" "$HOME/.direnvrc"
    ln -s "$(pwd)/.zshrc" "$HOME/.zshrc"
    ln -s "$(pwd)/.config/starship.toml" "$HOME/.config/starship.toml"
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    chsh -s $(which zsh)
    finished "shell (zsh/antigen/starship/fonts/gogh)"
}

TMUX="tmux"; SECTIONS+=("$TMUX")
function run_tmux {
    begin "$TMUX" "terminal multiplexer"
    sudo snap install tmux --classic
    ln -s "$(pwd)/.tmux.conf" "$HOME/.tmux.conf"
    mkdir -p "$HOME/.local/bin"
    ln -s "$(pwd)/.local/bin/tmux-dev" "$HOME/.local/bin/tmux-dev"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    # Install TPM plugins and copy custom Tomorrow Night theme
    ~/.tmux/plugins/tpm/bin/install_plugins
    cp "$(pwd)/.config/tmux/tomorrow_night.conf" ~/.tmux/plugins/tmux/themes/catppuccin_tomorrow_night_tmux.conf
    finished "tmux"
}

NVIM="nvim"; SECTIONS+=("$NVIM")
function run_nvim {
    begin "$NVIM" "the one true editor"
    sudo snap install nvim --classic
    sudo apt-get install -y cargo ripgrep lua5.1 luarocks
    # Backup existing nvim config
    mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null
    mv ~/.local/state/nvim ~/.local/state/nvim.bak 2>/dev/null
    mv ~/.cache/nvim ~/.cache/nvim.bak 2>/dev/null
    ln -s "$(pwd)/.config/astronvim_v5" "$HOME/.config/nvim"
    finished "nvim (AstroNvim)"
}

VIM="vim"; SECTIONS+=("$VIM")
function run_vim {
    begin "$VIM" "the classic"
    sudo apt-get install -y vim
    ln -s "$(pwd)/.vimrc" "$HOME/.vimrc"
    mkdir -p ~/.vim/autoload ~/.vim/bundle
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    finished "vim"
}

# =============================================================================
# DEV TOOLS
# =============================================================================

RUST="rust"; SECTIONS+=("$RUST")
function run_rust {
    begin "$RUST" "removing footguns while politely judging you"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    finished "rust"
}

PYTHON="python"; SECTIONS+=("$PYTHON")
function run_python {
    begin "$PYTHON" "dead snakes"
    sudo apt-get install -y python3-pip python3-venv python3-dev
    finished "python"
}

NODEJS="nodejs"; SECTIONS+=("$NODEJS")
function run_nodejs {
    begin "$NODEJS" "a sword without a hilt, careful."
    curl -o- https://fnm.vercel.app/install | bash
    fnm install 22
    node -v
    npm -v
    finished "nodejs"
}

DOCKER="docker"; SECTIONS+=("$DOCKER")
function run_docker {
    begin "$DOCKER" "'agua mala', the man said, 'you whore'"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    echo "don't forget to..."
    echo "sudo groupadd docker; sudo usermod -aG docker $USER"
    echo "...later"
    finished "docker"
}

HARLEQUIN="harlequin"; SECTIONS+=("$HARLEQUIN")
function run_harlequin {
    begin "$HARLEQUIN" "the gardens of love"
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source "$HOME/.cargo/env"
    uv tool install 'harlequin[postgres,mysql,s3]'
    finished "harlequin"
}

# =============================================================================
# DESKTOP & APPS
# =============================================================================

GNOME="gnome"; SECTIONS+=("$GNOME")
function run_gnome {
    begin "$GNOME" "diggy diggy hole!"
    sudo apt-get install -y gnome-system-tools dconf-editor gnome-tweaks gnome-shell-extensions
    # Load saved dconf settings
    dconf load / < dconf/dconf-24.04.ini
    finished "gnome"
}

CHROME="chrome"; SECTIONS+=("$CHROME")
function run_chrome {
    begin "$CHROME" "because of reasons"
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt-get install -y ./google-chrome-stable_current_amd64.deb chrome-gnome-shell
    finished "chrome"
}

APPS="apps"; SECTIONS+=("$APPS")
function run_apps {
    begin "$APPS" "appppppppppps!"
    # Snaps
    sudo snap install discord --classic
    sudo snap install signal-desktop
    sudo snap install tradingview --classic
    # Flatpaks
    flatpak install -y flathub com.mastermindzh.tidal-hifi
    finished "apps"
}

# =============================================================================
# RUNNER
# =============================================================================

ALL_DONE="all_done"
function run_all_done {
    begin "all done... bye bye."
    finished "all done"
}

if [ "$#" -eq 0 ]; then
    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "┃ Available sections:"
    echo "┃"
    echo "┃ CORE"
    for i in 0 1; do
        echo "┃   $((i+1)). ${SECTIONS[i]}"
    done
    echo "┃"
    echo "┃ TERMINAL ENVIRONMENT"
    for i in 2 3 4 5; do
        echo "┃   $((i+1)). ${SECTIONS[i]}"
    done
    echo "┃"
    echo "┃ DEV TOOLS"
    for i in 6 7 8 9 10; do
        echo "┃   $((i+1)). ${SECTIONS[i]}"
    done
    echo "┃"
    echo "┃ DESKTOP & APPS"
    for i in 11 12 13; do
        echo "┃   $((i+1)). ${SECTIONS[i]}"
    done
    echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    read -p "Do you want to run all sections? (y/n): " run_all
    if [ "$run_all" == "y" ]; then
        for section in "${SECTIONS[@]}"; do
            function_name="run_${section}"
            $function_name
        done
    else
        read -p "Enter the numbers of the sections to run, separated by spaces: " sections
        for index in $sections; do
            section="${SECTIONS[index-1]}"
            function_name="run_${section}"
            $function_name
        done
    fi
else
    for index in "$@"; do
        section="${SECTIONS[index-1]}"
        function_name="run_${section}"
        $function_name
    done
fi

# Always run the "all done" section last
run_all_done
