#!/bin/bash
set -e
sudo apt update
sudo apt upgrade -y

sudo apt -y install git curl wget unzip build-essential net-tools
sudo apt -y install emacs vim tmux ranger htop

# TODO gui related stuff only when parameter gui is passed
sudo apt -y install xclip terminator pcmanfm
# sudo apt -y install awesome
sudo apt -y install i3 i3blocks rofi imagemagick
# install playerctl to easy control audio players like spotify https://github.com/altdesktop/playerctl/releases
wget https://github.com/altdesktop/playerctl/releases/download/v2.2.1/playerctl-2.2.1_amd64.deb
sudo dpkg -i playerctl-2.2.1_amd64.deb
rm playerctl-2.2.1_amd64.deb

function installZsh() {
    sudo apt -y install zsh
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

function installDotnetCore() {
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb

    sudo apt update
    sudo apt install -y apt-transport-https
    sudo apt update
    sudo apt install -y dotnet-sdk-3.1
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
