#!/bin/bash
set -e
tmpDir=$(mktemp -d)
cd $tmpDir
# install nerd-font hack
wget -O hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip
unzip hack.zip -d hack
sudo mkdir /usr/share/fonts/truetype/hack
sudo mv hack/*.ttf /usr/share/fonts/truetype/hack
cd ~
rm -rf $tmpDir
sudo fc-cache -fv
