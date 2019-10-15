#!/bin/bash

sudo apt update
sudo apt upgrade -y

sudo apt -y install git curl wget
sudo apt -y install build-essential emacs vim tmux xclip zsh terminator ranger htop
# sudo apt -y install i3 chromium-browser

# TODO set zsh as default shell, install oh-my-zsh and powerlevel9k zsh theme
