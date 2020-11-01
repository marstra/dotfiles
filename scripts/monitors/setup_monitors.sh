#!/usr/bin/env bash

# DVI-D-0 => Right Monitor
# HDMI-0 => Middle Monitor
# DP-3 => Left Monitor
xrandr --output DP-3 --pos 0x0 --rotate normal --output HDMI-0 --pos 1920x0 --rotate normal --primary --output DVI-D-0 --pos 3840x0 --rotate normal
