#!/bin/bash

BASE_DIR=$(realpath "$(dirname $(readlink -f $0))/..")

function link (){
	src="$BASE_DIR/$1"
	dst=$2
	dstDir=$(dirname $dst)
	mkdir -p $dstDir
	rm $dst
	ln -s $src $dst
}

link terminator/config ~/.configs/terminator/config
link git/.gitconfig ~/.gitconfig