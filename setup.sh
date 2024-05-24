#!/bin/bash

ask_user() {
    read -p "┃ ? (Y/n): " choice
    case "$choice" in
        n|N ) return 1;;
        * ) return 0;;
    esac
}

begin() {
    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "┃ $1"
    echo "┃ -----"
    echo "┃ $2"
    echo "┃"
    if ! ask_user; then
        echo "┃ Skipping $1"
        echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        return 1
    fi
    echo "┗-------------------------------------------------------"
    return 0
}

finished() {
    echo "┏-------------------------------------------------------"
    echo "┃ ...done with $1"
    echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

if begin "aptitude packages" "the fundaments of awesome"; then
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y zsh htop git curl tldr build-essential libssl-dev snapd direnv
    finished "aptitude packages"
fi

if begin "zsh/antigen/starship" "command line sweet sauce"; then
    sudo usermod -s /usr/bin/zsh $(whoami)
    curl -L git.io/antigen > ~/.antigen.zsh
    ln -s "$(pwd)/.antigenrc" "$HOME/.antigenrc"
    ln -s "$(pwd)/.direnvrc" "$HOME/.direnvrc"
    ln -s "$(pwd)/.vimrc" "$HOME/.vimrc"
    ln -s "$(pwd)/.zshrc" "$HOME/.zshrc"
    ln -s "$(pwd)/.config/starship.toml" "$HOME/.config/starship.toml"
    # based on gruvbox-rainbow <3
    # starship preset gruvbox-rainbow -o ~/.config/starship.toml
    curl -sS https://starship.rs/install.sh | sh
    chsh -s $(which zsh)
    finished "zsh/antigen/starship"
fi

if begin "gnome-tweaks/gogh/nerd-fonts" "because what you're really after... is ~sway~"; then
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip
    unzip FiraCode.zip -d FiraCode
    sudo mkdir -p /usr/share/fonts/truetype/fira-code-nerd
    sudo cp FiraCode/* /usr/share/fonts/truetype/fira-code-nerd/
    sudo fc-cache -fv
    sudo apt-get install -y gnome-system-tools dconf-editor gnome-tweaks gnome-shell-extensions
    # Tomorrow Night is absolute fire
    # but these are also very decent
    # themes=("119 120 168 225 247 248") # Kanagawa, SpaceDust, Nord, Tokyo Night
    echo "253" | bash -c "$(wget -qO- https://git.io/vQgMr)" # Tomorrow Night <3
    finished "~sway~"
fi


if begin "snaps" "snap me up, bruh"; then
    sudo snap install code --classic
    sudo snap install spotify --classic
    sudo snap install discord --classic
    sudo snap install 1password --classic
    sudo snap install tradingview --classic
    sudo snap install gnome-boxes --classic
    # if for whatever sad reason you still/again have a day job, uncomment these
    # sudo snap install slack --classic     
    # sudo snap install flameshot --classic 
    # sudo snap install postman --classic   
    # sudo snap install gimp --classic      
    finished "snaps"
fi

if begin "chrome" "because of reasons"; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt-get install -y ./google-chrome-stable_current_amd64.deb chrome-gnome-shell
    finished "chrome"
fi

if begin "python, git and vim" "programming dead snakes"; then
    mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    sudo apt-get install -y python3-pip python3-venv python3-dev gparted kazam ncdu vim
    git config --global user.email "jhnwsk@gmail.com"
    git config --global user.name "Jan Wąsak"
    git config --global core.editor "vim"
    finished "python and vim"
fi

if begin "node.js" "a sword without a hilt, careful."; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
    sudo xargs npm install --global < package-list.txt
    finished "node.js"
fi

if begin "docker" "'agua mala', the man said, 'you whore'"; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    echo "don't forget to..."
    echo "sudo groupadd docker; sudo usermod -aG docker $USER"
    echo "...later"
    finished "docker"
fi

if begin "grub" "you're dual booting need not be fugly"; then
    git clone git@github.com:vinceliuice/grub2-themes.git       
    sudo ./grub2-themes/install.sh -s 4k
fi

if begin "dconf" "some things never change, this rarely works"; then
    dconf load / < dconf/dconf-24.04.ini
    # this will load a thing you've exported before using
    # dconf dump / > dconf-where-from.ini
    # if this ain't working, and it never does, try these
    # gsettings set org.gnome.desktop.background picture-uri "file://$(pwd)/wallpapers/firewatch-neon-tokyo.png"
    # gsettings set org.gnome.desktop.calendar show-weekdate true
    finished "dconf"
fi

echo "all done... bye bye."
    finished "all done"
fi
