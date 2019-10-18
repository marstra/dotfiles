#!/bin/bash

BASE_DIR=$(realpath "$(dirname $(readlink -f $0))/..")

function link (){
	src="$BASE_DIR/$1"
	dst=$2
	dstDir=$(dirname $dst)
	mkdir -p $dstDir
	rm -rf $dst
	echo "make link from $src to $dst"
	ln -s $src $dst
}

link terminator/config ~/.config/terminator/config
link git/.gitconfig ~/.gitconfig
link zsh/.zshrc ~/.zshrc
link zsh/.zshenv ~/.zshenv
link emacs/.emacs.d ~/.emacs.d