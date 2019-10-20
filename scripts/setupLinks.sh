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

function rootlink (){
    src="$BASE_DIR/$1"
    dst=$2
    dstDir=$(dirname $dst)
    echo "make link as root from $src to $dst"
    sudo mkdir -p $dstDir
    sudo rm -rf $dst
    sudo ln -s $src $dst
}

link terminator/config ~/.config/terminator/config
link git/.gitconfig ~/.gitconfig
link zsh/.zshrc ~/.zshrc
link zsh/.zshenv ~/.zshenv
link emacs/.emacs.d ~/.emacs.d
link vim/.vimrc ~/.vimrc
link vim/.vim ~/.vim
link awesome ~/.config/awesome
rootlink gdm3/monitors.xml /var/lib/gdm3/.config/monitors.xml
sudo chown gdm:gdm /var/lib/gdm3/.config/monitors.xml
rootlink gdm3/custom.conf /etc/gdm3/custom.conf
