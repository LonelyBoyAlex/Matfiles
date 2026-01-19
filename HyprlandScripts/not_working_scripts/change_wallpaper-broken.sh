#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures"

# Select a random wallpaper and set it
function change_wallpaper {
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
    swww img "$WALLPAPER" -t any
}

# Run the function once at startup
change_wallpaper

# Wait for 24 hours
while true; do
    sleep 86400
    change_wallpaper
done

