#!/bin/bash

echo "########################"
echo "# Install apt packages"
echo "########################"

sudo apt update
sudo apt upgrade
sudo apt install -y python3-pip zsh htop git curl tldr build-essential libssl-dev snapd

echo "\n\n"

echo "########################"
echo "# Configure ZSH/Antigen"
echo "########################"

sudo usermod -s /usr/bin/zsh $(whoami)
curl -L git.io/antigen > ~/antigen.zsh
cp .zshrc ~/.zshrc
cp .antigenrc ~/.antigenrc

echo "\n\n"

echo "########################"
echo "# Snap me up, bruh"
echo "########################"

sudo snap install code --classic
sudo snap install slack --classic
sudo snap install postman --classic
sudo snap install gnome-boxes --classic

echo "\n\n"

echo "########################"
echo "# Install Chrome browser"
echo "########################"

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.debecho 

echo "########################"
echo "# Install Docker"
echo "########################"

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

echo "\n\n"

echo "########################"
echo "EXECUTE THIS COMMAND AFTER REBOOT:"
echo "sudo groupadd docker; sudo usermod -aG docker $USER"
echo "########################"
