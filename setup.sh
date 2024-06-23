#!/bin/bash
source ./setup_fns.sh

# Create an array to hold the section names
SECTIONS=()

# Define section name variables and corresponding functions
APT="aptitude"; SECTIONS+=("$APT")
function run_aptitude {
    begin "$APT" "the fundaments of awesome"
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y zsh htop git curl tldr build-essential libssl-dev snapd direnv gparted ncdu
    finished "aptitude packages"
}

ZSH="starship"; SECTIONS+=("$ZSH")
function run_starship {
    begin "zsh/antigen/starship" "command line sweet sauce"
    sudo usermod -s /usr/bin/zsh $(whoami)
    curl -L git.io/antigen > ~/.antigen.zsh
    ln -s "$(pwd)/.antigenrc" "$HOME/.antigenrc"
    ln -s "$(pwd)/.direnvrc" "$HOME/.direnvrc"
    ln -s "$(pwd)/.zshrc" "$HOME/.zshrc"
    ln -s "$(pwd)/.config/starship.toml" "$HOME/.config/starship.toml"
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    chsh -s $(which zsh)
    finished "zsh/antigen/starship"
}

GNOME="gnome"; SECTIONS+=("$GNOME")
function run_gnome{
    begin "gnome-tweaks/gogh/nerd-fonts" "because what you're really after... is ~sway~"
    curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash
    getnf -i "FiraCode FiraMono"
    sudo apt-get install -y gnome-system-tools dconf-editor gnome-tweaks gnome-shell-extensions
    echo "252" | bash -c "$(wget -qO- https://git.io/vQgMr)"
    finished "gnome-tweaks/gogh/nerd-fonts"
}

SNAPS="snaps"; SECTIONS+=("$SNAPS")
function run_snaps {
    begin "snaps" "snap me up, bruh"
    sudo snap install code --classic
    sudo snap install spotify --classic
    sudo snap install discord --classic
    sudo snap install tradingview --classic
    finished "snaps"
}

CHROME="chrome"; SECTIONS+=("$CHROME")
function run_chrome {
    begin "chrome" "because of reasons"
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt-get install -y ./google-chrome-stable_current_amd64.deb chrome-gnome-shell
    finished "chrome"
}

PYTHON="python"; SECTIONS+=("$PYTHON")
function run_python {
    begin "python" "dead snakes"
    sudo apt-get install -y python3-pip python3-venv python3-dev
    finished "python"
}

NODEJS="nodejs"; SECTIONS+=("$NODEJS")
function run_nodejs {
    begin "node.js" "a sword without a hilt, careful."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
    sudo xargs npm install --global < package-list.txt
    finished "node.js"
}

ASTRO_VIM="astro_vim"; SECTIONS+=("$ASTRO_VIM")
function run_astro_vim_and_git_configuration {
    begin "(astro)vim and git configuration" "doing things the hard way"
    ln -s "$(pwd)/.vimrc" "$HOME/.vimrc"
    sudo apt-get install -y vim neovim cargo ripgrep lua5.1 luarocks
    mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    mv ~/.local/share/nvim ~/.local/share/nvim.bak
    mv ~/.local/state/nvim ~/.local/state/nvim.bak
    mv ~/.cache/nvim ~/.cache/nvim.bak
    ln -s "$(pwd)/.config/nvim" "$HOME/.config/nvim"
    git config --global user.email "jhnwsk@gmail.com"
    git config --global user.name "Jan Wąsak"
    git config --global core.editor "vim"
    finished "(astro)vim and git configuration"
}

DOCKER="docker"; SECTIONS+=("$DOCKER")
function run_docker {
    begin "docker" "'agua mala', the man said, 'you whore'"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    echo "don't forget to..."
    echo "sudo groupadd docker; sudo usermod -aG docker $USER"
    echo "...later"
    finished "docker"
}

GRUB="grub"; SECTIONS+=("$GRUB")
function run_grub {
    begin "grub" "you're dual booting need not be fugly"
    git clone git@github.com:vinceliuice/grub2-themes.git
    sudo ./grub2-themes/install.sh -s 4k
}

DCONF="dconf"; SECTIONS+=("$DCONF")
function run_dconf {
    begin "dconf" "some things never change, this rarely works"
    dconf load / < dconf/dconf-24.04.ini
    finished "dconf"
}

ALL_DONE="all_done"
function run_all_done {
    begin "all done... bye bye."
    finished "all done"
}


if [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

if [ "$#" -eq 0 ]; then
    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "┃ Available sections:"
    echo "┃"
    for i in "${!SECTIONS[@]}"; do
        echo "┃ $((i+1)). ${SECTIONS[i]}"
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

