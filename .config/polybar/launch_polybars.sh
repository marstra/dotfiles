#!/usr/bin/env bash

CONFIG="--config=$HOME/repos/dotfiles/.config/polybar/config.ini"

polybar-msg cmd quit

polybar $CONFIG left 2>&1 | tee -a /tmp/polybar_left.log & disown

