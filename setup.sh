#!/bin/bash
source ./setup_fns.sh

if begin "aptitude packages" "the fundaments of awesome"; then
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y zsh htop git curl tldr build-essential libssl-dev snapd direnv gparted ncdu
    finished "aptitude packages"
fi

if begin_ask "zsh/antigen/starship" "command line sweet sauce"; then
    sudo usermod -s /usr/bin/zsh $(whoami)
    curl -L git.io/antigen > ~/.antigen.zsh
    ln -s "$(pwd)/.antigenrc" "$HOME/.antigenrc"
    ln -s "$(pwd)/.direnvrc" "$HOME/.direnvrc"
    ln -s "$(pwd)/.vimrc" "$HOME/.vimrc"
    ln -s "$(pwd)/.zshrc" "$HOME/.zshrc"
    ln -s "$(pwd)/.config/starship.toml" "$HOME/.config/starship.toml"
    ln -s "$(pwd)/.config/lvim" "$HOME/.config/lvim"
    # based on gruvbox-rainbow <3
    # starship preset gruvbox-rainbow -o ~/.config/starship.toml
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    chsh -s $(which zsh)
    finished "zsh/antigen/starship"
fi

if begin_ask "gnome-tweaks/gogh/nerd-fonts" "because what you're really after... is ~sway~"; then
    # getnf is boss
    curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash
    getnf -i "FiraCode FiraMono"

    sudo apt-get install -y gnome-system-tools dconf-editor gnome-tweaks gnome-shell-extensions

    # Tomorrow Night is absolute fire
    # but these are also very decent
    # themes=("93 94 119 120 168 225 247 248") # Gruvbox Dark/Material Kanagawa, SpaceDust, Nord, Tokyo Night
    echo "252" | bash -c "$(wget -qO- https://git.io/vQgMr)" # Tomorrow Night <3
    finished "~sway~"
fi

if begin_ask "snaps" "snap me up, bruh"; then
    sudo snap install code --classic
    sudo snap install spotify --classic
    sudo snap install discord --classic
    sudo snap install tradingview --classic
    # if for whatever sad reason you still/again have a day job, uncomment these
    # sudo snap install gnome-boxes --classic
    # sudo snap install slack --classic     
    # sudo snap install flameshot --classic 
    # sudo snap install postman --classic   
    # sudo snap install gimp --classic      
    finished "snaps"
fi

if begin_ask "chrome" "because of reasons"; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt-get install -y ./google-chrome-stable_current_amd64.deb chrome-gnome-shell
    finished "chrome"
fi

if begin_ask "python" "dead snakes"; then
    sudo apt-get install -y python3-pip python3-venv python3-dev
    finished "dead snakes"
fi

if begin_ask "node.js" "a sword without a hilt, careful."; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
    sudo xargs npm install --global < package-list.txt
    finished "node.js"
fi

if begin_ask "lunar vim and git configuration" "doing things the hard way"; then
    sudo apt-get install -y vim neovim cargo ripgrep
    mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

    # LunarVim needs python for whatever reason
    python3 -m venv .venv --system-site-packages
    source .venv/bin/activate
    LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh)
    deactivate

    git config --global user.email "jhnwsk@gmail.com"
    git config --global user.name "Jan Wąsak"
    git config --global core.editor "vim"

    finished "doing things the hard way"
fi

if begin_ask "docker" "'agua mala', the man said, 'you whore'"; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    echo "don't forget to..."
    echo "sudo groupadd docker; sudo usermod -aG docker $USER"
    echo "...later"
    finished "docker"
fi

if begin_ask "grub" "you're dual booting need not be fugly"; then
    git clone git@github.com:vinceliuice/grub2-themes.git       
    sudo ./grub2-themes/install.sh -s 4k
fi

if begin_ask "dconf" "some things never change, this rarely works"; then
    dconf load / < dconf/dconf-24.04.ini
    # this will load a thing you've exported before using
    # dconf dump / > dconf-where-from.ini
    # if this ain't working, and it never does, try these
    # gsettings set org.gnome.desktop.background picture-uri "file://$(pwd)/wallpapers/firewatch-neon-tokyo.png"
    # gsettings set org.gnome.desktop.calendar show-weekdate true
    finished "dconf"
fi

begin "all done... bye bye."
finished "all done"

