#!/bin/bash

echo "########################"
echo "# apt packages"
echo "# the fundaments of awesome"
echo "########################"

sudo apt update
sudo apt upgrade
sudo apt install -y zsh htop git curl tldr build-essential libssl-dev snapd

echo "\n\n"

echo "########################"
echo "# zsh/antigen/starship"
echo "# command line sweet sauce"
echo "########################"

sudo usermod -s /usr/bin/zsh $(whoami)
curl -L git.io/antigen > ~/antigen.zsh
cp .zshrc ~/.zshrc
cp .antigenrc ~/.antigenrc
curl -sS https://starship.rs/install.sh | sh

echo "\n\n"

echo "########################"
echo "# gogh/nerd-fonts"
echo "# because what you're really after... is sway"
echo "########################"

bash -c  "$(wget -qO- https://git.io/vQgMr)" 

echo "########################"
echo "# snaps"
echo "# snap me up, bruh"
echo "########################"

sudo snap install code --classic
sudo snap install slack --classic
sudo snap install postman --classic
sudo snap install gnome-boxes --classic
sudo snap install 1password --classic
sudo snap install gimp --classic
sudo snap install spotify --classic

echo "\n\n"

echo "########################"
echo "# chrome"
echo "# because of reasons"
echo "########################"

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.debecho 

echo "########################"
echo "# docker"
echo "# 'agua mala', the man said, 'you whore'"
echo "########################"

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

echo "\n\n"

echo "########################"
echo "EXECUTE THIS COMMAND AFTER REBOOT:"
echo "sudo groupadd docker; sudo usermod -aG docker $USER"
echo "########################"
