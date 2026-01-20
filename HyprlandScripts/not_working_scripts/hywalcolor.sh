#!/bin/bash

# Get the current wallpaper path using swww
WALLPPER=$(swww query | grep -oP 'currently displaying: image: \K.*')

# Check if the wallpaper path is not empty
if [ -n "$WALLPPER" ]; then
    # Generate colors using wal
    wal -i "$WALLPPER"
else
    echo "No wallpaper found."
fi

hyprctl reload
