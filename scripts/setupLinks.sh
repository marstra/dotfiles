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

link zsh/.zshrc ~/.zshrc
link zsh/.zshenv ~/.zshenv
link zsh/.p10k.zsh ~/.p10k.zsh
link emacs/.emacs.d ~/.emacs.d
link vim/.vimrc ~/.vimrc
link vim/.vim ~/.vim
link tmux/.tmux.conf ~/.tmux.conf
