#!/usr/bin/env bash

# CONFIG="--config=$HOME/.config/polybar/config.ini"

polybar-msg cmd quit

if type "xrandr"; then
  for MONITOR in $(polybar -m | cut -d":" -f1); do
    export MONITOR
    echo "start polybar on $MONITOR"
    polybar --reload $CONFIG mybar 2>&1 | tee -a /tmp/polybar_monitor_${MONITOR}.log & disown
  done
else
  echo "could not start polybar" >&2
  exit 1
fi
