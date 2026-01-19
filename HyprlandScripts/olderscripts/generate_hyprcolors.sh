#!/bin/bash

#################
#this script cahnges the colors.conf file inside hypr
##################

# Path to your colors file and lookandfeel.conf
COLORS_FILE="$HOME/.cache/wal/colors"
LOOKANDFEEL_CONF="$HOME/.config/hypr/colors.conf"

# Read colors from the colors file into an array
mapfile -t COLORS < "$COLORS_FILE"

# Backup current lookandfeel.conf (optional)
# cp "$LOOKANDFEEL_CONF" "$LOOKANDFEEL_CONF.bak"

# Write new colors to lookandfeel.conf, replacing existing content
{
    echo ""
    echo "#####################"
    echo "### COLOR SETTINGS ###"
    echo "#####################"
    echo "\$background = rgb(${COLORS[0]:1})"
    echo "\$foreground = rgb(${COLORS[7]:1})"
    echo "\$cursor = rgb(${COLORS[7]:1})"
    for i in {0..15}; do
        echo "\$color$i = rgb(${COLORS[i]:1})"
    done
} > "$LOOKANDFEEL_CONF"

echo "Updated lookandfeel.conf with new colors."

