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
link zsh/.zshrc ~/.zshrc
link zsh/.zshenv ~/.zshenv
link emacs/.emacs.d ~/.emacs.d
link vim/.vimrc ~/.vimrc
link vim/.vim ~/.vim
link awesome ~/.config/awesome
link x/.xprofile ~/.xprofile
link i3 ~/.config/i3
link i3/i3blocks/i3blocks.conf ~/.i3blocks.conf
link idea/config ~/.WebStorm*/config
