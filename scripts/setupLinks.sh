#!/bin/bash
set -e
BASE_DIR=$(realpath "$(dirname $(readlink -f $0))/..")

function link (){
    src="$BASE_DIR/$1"
    dst=$2
    dstDir=$(dirname $dst)
    echo "make link from $src to $dst"
    mkdir -p $dstDir
    rm -rf $dst
    ln -s $src $dst
}

function rootCopy (){
    src="$BASE_DIR/$1"
    dst=$2
    dstDir=$(dirname $dst)
    echo "make copy as root from $src to $dst"
    sudo mkdir -p $dstDir
    sudo rm -rf $dst
    sudo cp $src $dst
}

link terminator/config ~/.config/terminator/config
# this might be no good idea, since the mail address might vary depending on the branch
#  => branch switches change mail address in commits
# link git/.gitconfig ~/.gitconfig
link zsh/.zshrc ~/.zshrc
link zsh/.zshenv ~/.zshenv
link emacs/.emacs.d ~/.emacs.d
link vim/.vimrc ~/.vimrc
link vim/.vim ~/.vim
link awesome ~/.config/awesome
link x/.xprofile ~/.xprofile
link i3 ~/.config/i3
link i3/i3blocks.conf ~/.i3blocks.conf
link idea/config ~/.WebStorm*/config

# has to be copied, symlinks to not work right here ... wait for Ubuntu 20.04 which claims to have fixed multiple monitor support of gdm
rootCopy gdm3/monitors.xml /var/lib/gdm3/.config/monitors.xml
sudo chown gdm:gdm /var/lib/gdm3/.config/monitors.xml
rootCopy gdm3/custom.conf /etc/gdm3/custom.conf

link scripts/monitors/setupMonitorsNormal.sh ~/.local/bin/setupMonitorsNormal.sh
