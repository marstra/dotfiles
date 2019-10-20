#!/bin/bash
set -e
sudo apt update
sudo apt upgrade -y

sudo apt -y install git curl wget unzip build-essential
sudo apt -y install emacs vim tmux ranger htop

# TODO gui related stuff only when parameter gui is passed
sudo apt -y chromium-browser xclip terminator
# sudo apt -y install i3 

function installZsh() {
	sudo apt -y install zsh
	# TODO fix oh-my-zsh install, so no user interaction is needed in this step
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
}

function installDocker() {
	# see: https://docs.docker.com/install/linux/docker-ce/ubuntu/
	sudo apt -y install \
	    apt-transport-https \
	    ca-certificates \
	    gnupg-agent \
	    software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository \
	   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	   $(lsb_release -cs) \
	   stable"
	sudo apt update
	sudo apt -y install docker-ce docker-ce-cli containerd.io
	# TODO add $USER to docker group?
}

installZsh
#installDocker
