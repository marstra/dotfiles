#!/bin/bash

# Check if nvidia-smi exists and is executable
if ! command -v nvidia-smi &> /dev/null; then
    echo ""
    exit 0
fi

# Get GPU temperature
TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)

# Define color ramps
if [ "$TEMP" -lt 50 ]; then
    COLOR="%{F#00FF00}"  # Green
elif [ "$TEMP" -lt 70 ]; then
    COLOR="%{F#FFFF00}"  # Yellow
else
    COLOR="%{F#FF0000}"  # Red
fi

# Print the temperature with color
echo "${COLOR}GPU: ${TEMP}°C%{F-}"
