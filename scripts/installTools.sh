#!/bin/bash

sudo apt update
sudo apt upgrade -y

sudo apt -y install git curl wget unzip
sudo apt -y install build-essential emacs vim tmux xclip zsh terminator ranger htop
# sudo apt -y install i3 chromium-browser

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
