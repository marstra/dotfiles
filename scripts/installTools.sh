#!/bin/bash
set -e
sudo apt update
sudo apt upgrade -y

sudo apt -y install curl wget less unzip build-essential net-tools


function setup_git() {
    sudo apt -y install git
    git config --global init.defaultBranch master
    git config --global user.email "mail@marstra.de"
    git config --global user.name "Markus Straußberger"
}

setup_git

sudo snap install btop
sudo snap install --classic code
sudo snap install --classic emacs
git clone https://github.com/syl20bnr/spacemacs $HOME/.emacs.d

sudo apt -y install vim ranger ripgrep

function install_tmux() {
    sudo apt install -y tmux
    cd $HOME
    git clone https://github.com/gpakosz/.tmux.git
    ln -s -f .tmux/.tmux.conf
    cp .tmux/.tmux.conf.local .
}

# TODO gui related stuff only when parameter gui is passed
sudo apt -y install xclip alacritty pcmanfm
# sudo apt -y install awesome
sudo apt -y install i3 polybar rofi imagemagick
# install playerctl to easy control audio players like spotify https://github.com/altdesktop/playerctl/releases
wget https://github.com/altdesktop/playerctl/releases/download/v2.2.1/playerctl-2.2.1_amd64.deb
sudo dpkg -i playerctl-2.2.1_amd64.deb
rm playerctl-2.2.1_amd64.deb

function installZsh() {
    sudo apt -y install zsh fzf bat
    echo "change default shell for $USER to zsh"
    chsh $USER -s /usr/bin/zsh
}

function installChrome() {
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    rm -f google-chrome-stable_current_amd64.deb
    xdg-settings set default-web-browser google-chrome.desktop
}

function installNodeJS() {
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    nvm install --lts
}

function installDotnet() {
    wget https://dot.net/v1/dotnet-install.sh
    chmod +x ./dotnet-install.sh
    ./dotnet-install.sh
    rm -f dotnet-install.sh
}

function installDocker() {
    # see: https://docs.docker.com/install/linux/docker-ce/ubuntu/
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh

    sudo usermod -aG docker $USER
}

function installDockerCompose() {
    # see: https://docs.docker.com/install/linux/docker-ce/ubuntu/
    sudo curl -L https://github.com/docker/compose/releases/download/v2.11.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
}

function installReversing() {
    # install radare
    sudo mkdir /opt/radare2
    cd /opt/radare2
    ./sys/install.sh
    # install gdb+gef and readelf
    sudo apt instsall gdb readelf
    wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh
}

installZsh
installChrome
installDocker
installDockerCompose
installNodeJS
# installDotnetCore

# increase number of inotify watchers, so webpack watch works, see https://github.com/guard/listen/wiki/Increasing-the-amount-of-inotify-watchers
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
