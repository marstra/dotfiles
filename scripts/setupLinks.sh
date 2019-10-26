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
# this might be no good idea, since the mail address might vary depending on the branch
#  => branch switches change mail address in commits
# link git/.gitconfig ~/.gitconfig
link zsh/.zshrc ~/.zshrc
link zsh/.zshenv ~/.zshenv
link emacs/.emacs.d ~/.emacs.d
link vim/.vimrc ~/.vimrc
link vim/.vim ~/.vim
link awesome ~/.config/awesome
link i3 ~/.config/i3
link idea/config ~/.WebStorm*/config
