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
    echo "┃ Done with $1"
    echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Update package repositories and upgrade existing packages
begin "aptitude packages" "the fundaments of awesome"
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y zsh htop git curl tldr build-essential libssl-dev snapd
finished "aptitude packages"

# Configure zsh with antigen and starship prompt
begin "zsh/antigen/starship" "command line sweet sauce"
sudo usermod -s /usr/bin/zsh $(whoami)
curl -L git.io/antigen > ~/antigen.zsh
cp .zshrc ~/.zshrc
cp .antigenrc ~/.antigenrc
curl -sS https://starship.rs/install.sh | sh
finished "zsh/antigen/starship"

# Install Gogh and Nerd Fonts
begin "gogh/nerd-fonts" "because what you're really after... is sway"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip
unzip FiraCode.zip -d FiraCode
sudo mkdir -p /usr/share/fonts/truetype/fira-code-nerd
sudo cp FiraCode/* /usr/share/fonts/truetype/fira-code-nerd/
sudo fc-cache -fv
fc-list | grep "Fira Code"
bash -c "$(wget -qO- https://git.io/vQgMr)"
sudo apt install -y dconf-editor
# Load GNOME Terminal profiles from file
# dconf load /org/gnome/terminal/legacy/profiles:/ < gogh-tokyo-night.dconf
finished "gogh/nerd-fonts"

# Install Snap packages
begin "snaps" "snap me up, bruh"
sudo snap install code --classic
sudo snap install slack --classic
sudo snap install postman --classic
sudo snap install gnome-boxes --classic
sudo snap install 1password --classic
sudo snap install gimp --classic
sudo snap install spotify --classic
finished "snaps"

# Install Google Chrome
begin "chrome" "because of reasons"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get install -y ./google-chrome-stable_current_amd64.debecho
finished "chrome"

# Install Docker
begin "docker" "'agua mala', the man said, 'you whore'"
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
finished "docker"

# Post-installation instructions
begin "all done" "now it's time to..."
echo "sudo groupadd docker; sudo usermod -aG docker $USER"
finished "all done"
