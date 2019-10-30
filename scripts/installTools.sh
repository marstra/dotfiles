#!/bin/bash
set -e
sudo apt update
sudo apt upgrade -y

sudo apt -y install git curl wget unzip build-essential net-tools
sudo apt -y install emacs gnome-vim tmux ranger htop

# TODO gui related stuff only when parameter gui is passed
sudo apt -y install chromium-browser xclip terminator pcmanfm
# sudo apt -y install awesome
sudo apt -y install i3 i3blocks

function installZsh() {
	sudo apt -y install zsh
	# TODO fix oh-my-zsh install, so no user interaction is needed in this step
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
}

function installNodeJS() {
	curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
	sudo apt install -y nodejs
}

function installDotnetCore() {
	wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
	sudo dpkg -i packages-microsoft-prod.deb

	sudo add-apt-repository universe
	sudo apt update
	sudo apt install -y apt-transport-https
	sudo apt update
	sudo apt install -y dotnet-sdk-3.0
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
	sudo usermod -aG docker $USER
}

installZsh
installDocker
installNodeJS
installDotnetCore

# increase number of inotify watchers, so webpack watch works, see https://github.com/guard/listen/wiki/Increasing-the-amount-of-inotify-watchers
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
