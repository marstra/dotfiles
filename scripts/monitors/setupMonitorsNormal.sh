#!/usr/bin/env bash
# HDMI-0 => TV
# DVI-I-1 => Right Monitor
# DVI-D-0 => Middle Monitor
# DP-0 => Left Monitor
xrandr --output DVI-I-1 --pos 3840x0 --rotate normal --output DVI-D-0 --pos 1920x0 --rotate normal --output DP-0 --pos 0x0 --primary --rotate normal # --output HDMI-0 --pos 0x0 --rotate normal --mode 1920x1080
