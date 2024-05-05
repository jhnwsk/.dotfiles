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

begin "aptitude packages" "the fundaments of awesome"
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y zsh htop git curl tldr build-essential libssl-dev snapd
finished "aptitude packages"

begin "zsh/antigen/starship" "command line sweet sauce"
sudo usermod -s /usr/bin/zsh $(whoami)
curl -L git.io/antigen > ~/.antigen.zsh
ln -s "$(pwd)/.antigenrc" "$HOME/.antigenrc"
ln -s "$(pwd)/.direnvrc" "$HOME/.direnvrc"
ln -s "$(pwd)/.vimrc" "$HOME/.vimrc"
ln -s "$(pwd)/.zshrc" "$HOME/.zshrc"
curl -sS https://starship.rs/install.sh | sh
starship preset gruvbox-rainbow -o ~/.config/starship.toml
# if customizing the preset, do this instead
# ln -s .config/starship.toml ~/.config/starship.toml
chsh -s $(which zsh)
finished "zsh/antigen/starship"

begin "gnome-tweaks/gogh/nerd-fonts/gnome terminal" "because what you're really after... is ~sway~"
# still need to configure gnome terminal manually because export/import with dconf-editor is not working for some reason
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip
unzip FiraCode.zip -d FiraCode
sudo mkdir -p /usr/share/fonts/truetype/fira-code-nerd
sudo cp FiraCode/* /usr/share/fonts/truetype/fira-code-nerd/
sudo fc-cache -fv
sudo apt-get install -y gnome-system-tools dconf-editor gnome-tweaks gnome-shell-extensions
gsettings set org.gnome.desktop.background picture-uri "file://$(pwd)/firewatch-neon-tokyo.png"

# Tomorrow Night is absolute fire
# but these are also very decent
# themes=("119 120 168 225 247 248") # Kanagawa, SpaceDust, Nord, Tokyo Night
themes=("252") # Tomorrow Night <3
echo "$themes" | bash -c "$(wget -qO- https://git.io/vQgMr)"
finished "~sway~"

begin "snaps" "snap me up, bruh"
sudo snap install code --classic
sudo snap install spotify --classic
sudo snap install slack --classic
sudo snap install 1password --classic
sudo snap install flameshot --classic
sudo snap install tradingview --classic
sudo snap install postman --classic
sudo snap install gnome-boxes --classic
sudo snap install gimp --classic
finished "snaps"

begin "chrome" "because of reasons"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get install -y ./google-chrome-stable_current_amd64.debecho chrome-gnome-shell
finished "chrome"

begin "node/python" "because programming is fun, right?"
sudo apt-get install -y python3-pip python3-venv python3-dev direnv gparted indicator-multiload kazam ncdu vim
mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo xargs npm install --global < package-list.txt
pip install -r requirements.txt
finished "node/python"

begin "docker" "'agua mala', the man said, 'you whore'"
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
finished "docker"

begin "all done" "now it's time to..."
echo "sudo groupadd docker; sudo usermod -aG docker $USER"
finished "all done"
