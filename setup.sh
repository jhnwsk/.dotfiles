#!/bin/bash

begin() {
    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "┃ $1"
    echo "┃ -----"
    echo "┃ $2"
    echo "┗-------------------------------------------------------"
}

finished() {
    echo "┏-------------------------------------------------------"
    echo "┃ ...done with $1"
    echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

begin "aptitude packages" "the fundaments of awesome"
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y zsh htop git curl tldr build-essential libssl-dev snapd direnv
finished "aptitude packages"

begin "zsh/antigen/starship" "command line sweet sauce"
sudo usermod -s /usr/bin/zsh $(whoami)
curl -L git.io/antigen > ~/.antigen.zsh
ln -s "$(pwd)/.antigenrc" "$HOME/.antigenrc"
ln -s "$(pwd)/.direnvrc" "$HOME/.direnvrc"
ln -s "$(pwd)/.vimrc" "$HOME/.vimrc"
ln -s "$(pwd)/.zshrc" "$HOME/.zshrc"
ln -s .config/starship.toml ~/.config/starship.toml
# based on gruvbox-rainbow <3
# starship preset gruvbox-rainbow -o ~/.config/starship.toml
curl -sS https://starship.rs/install.sh | sh
chsh -s $(which zsh)
finished "zsh/antigen/starship"

begin "gnome-tweaks/gogh/nerd-fonts" "because what you're really after... is ~sway~"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip
unzip FiraCode.zip -d FiraCode
sudo mkdir -p /usr/share/fonts/truetype/fira-code-nerd
sudo cp FiraCode/* /usr/share/fonts/truetype/fira-code-nerd/
sudo fc-cache -fv
sudo apt-get install -y gnome-system-tools dconf-editor gnome-tweaks gnome-shell-extensions

# Tomorrow Night is absolute fire
# but these are also very decent
# themes=("119 120 168 225 247 248") # Kanagawa, SpaceDust, Nord, Tokyo Night
echo "252" | bash -c "$(wget -qO- https://git.io/vQgMr)" # Tomorrow Night <3
finished "~sway~"

begin "dconf" "some things never change"
dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal-profiles.dconf
# this will load a thing you've exported before using
# dconf dump / > dconf-where-from.ini
# if this ain't working, and it never does, try these
# gsettings set org.gnome.desktop.background picture-uri "file://$(pwd)/wallpapers/firewatch-neon-tokyo.png"
# gsettings set org.gnome.desktop.calendar show-weekdate true
finished "dconf"

begin "snaps" "snap me up, bruh"
sudo snap install code --classic
sudo snap install spotify --classic
sudo snap install slack --classic
sudo snap install discord --classic
sudo snap install 1password --classic
sudo snap install flameshot --classic
sudo snap install tradingview --classic
sudo snap install postman --classic
sudo snap install gnome-boxes --classic
sudo snap install gimp --classic
finished "snaps"

begin "chrome" "because of reasons"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get install -y ./google-chrome-stable_current_amd64.deb chrome-gnome-shell
finished "chrome"

begin "node/python" "because programming is fun, right?"
sudo apt-get install -y python3-pip python3-venv python3-dev gparted kazam ncdu vim
mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo xargs npm install --global < package-list.txt
pip install -r requirements.txt
finished "node/python/github"

begin "docker" "'agua mala', the man said, 'you whore'"
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
finished "docker"

begin "all done" "now it's time to..."
echo "sudo groupadd docker; sudo usermod -aG docker $USER"
finished "all done"
