#!/bin/bash
set -e
sudo apt update
sudo apt upgrade -y

sudo apt -y install tmux emacs25 vim build-essential

function installZsh() {
    sudo apt -y install zsh
    echo "change default shell for $USER to zsh"
    chsh $USER -s /usr/bin/zsh
}

function installDocker() {
    # see: https://docs.docker.com/install/linux/docker-ce/ubuntu/
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    sudo usermod -aG docker $USER
}

function setup_locales() {
    # install de_DE UTF8
    sudo dpkg-reconfigure locales
}

function installDockerCompose() {
    sudo apt -y install python3-pip
    sudo pip3 install docker-compose
}

installZsh
installDocker
installDockerCompose
