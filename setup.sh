#!/bin/bash
source ./setup_fns.sh

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
    # Gogh terminal theme (Tomorrow Night #252)
    echo "252" | bash -c "$(wget -qO- https://git.io/vQgMr)"
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
    finished "shell (zsh/antigen/starship/fonts/gogh)"
}

TMUX="tmux"; SECTIONS+=("$TMUX"); DESCRIPTIONS+=("terminal multiplexer")
function run_tmux {
    begin "$TMUX" "$(get_desc $TMUX)"
    sudo snap install tmux --classic
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
    sudo snap install nvim --classic
    sudo apt-get install -y cargo ripgrep lua5.1 luarocks
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
    sudo apt-get install -y vim
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
    sudo apt-get install -y python3-pip python3-venv python3-dev
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

GNOME="gnome"; SECTIONS+=("$GNOME"); DESCRIPTIONS+=("diggy diggy hole!")
function run_gnome {
    begin "$GNOME" "$(get_desc $GNOME)"
    sudo apt-get install -y gnome-system-tools dconf-editor gnome-tweaks gnome-shell-extensions
    # Load saved dconf settings
    dconf load / < dconf/dconf-24.04.ini
    finished "gnome"
}

CHROME="chrome"; SECTIONS+=("$CHROME"); DESCRIPTIONS+=("because of reasons")
function run_chrome {
    begin "$CHROME" "$(get_desc $CHROME)"
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt-get install -y ./google-chrome-stable_current_amd64.deb chrome-gnome-shell
    finished "chrome"
}

APPS="apps"; SECTIONS+=("$APPS"); DESCRIPTIONS+=("appppppppppps!")
function run_apps {
    begin "$APPS" "$(get_desc $APPS)"
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
