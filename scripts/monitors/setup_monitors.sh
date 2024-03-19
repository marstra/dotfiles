#!/usr/bin/env bash

# DVI-D-0 => Right Monitor
# HDMI-0 => Middle Monitor
# DP-3 => Left Monitor
xrandr --output DP-1 --pos 0x0 --rotate normal --output HDMI-0 --pos 2560x0 --rotate normal --primary --output HDMI-1 --pos 5120x0 --rotate normal
