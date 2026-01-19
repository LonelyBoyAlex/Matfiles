#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/Hyprpaper"

# Use rofi to select a wallpaper
SELECTED_FILE=$(cd "$WALLPAPER_DIR" && ls | rofi -dmenu -config ~/Downloads/rofidark.rasi)
if [[ -z "$SELECTED_FILE" ]]; then
    echo "No wallpaper selected, exiting."
    exit 1
fi

# Full path to the selected wallpaper
WALLPAPER="$WALLPAPER_DIR/$SELECTED_FILE"

# Set the wallpaper using swaybg
swaybg -i "$WALLPAPER" -m fill &

# Generate colors and update configurations
wal -i "$WALLPAPER"

# Update Rofi background
sed -i "s|background-image: url.*|background-image: url(\"$WALLPAPER\",width);|" ~/.config/rofi/coloredrofidark.rasi

# Call the color generation scripts
$HOME/HyprlandScripts/generate_hyprcolors.sh
$HOME/HyprlandScripts/hyprlockwalpath.sh
$HOME/HyprlandScripts/change_rofiwall7.sh

# Uncomment these lines if the scripts exist and are functional
# $HOME/HyprlandScripts/update_wofi_colors.sh
# $HOME/HyprlandScripts/dunstcolorsupdater.sh
# $HOME/HyprlandScripts/updatemakocolors.sh
# $HOME/HyprlandScripts/logoutmenucolorschanger.sh

# Reload kitty with new colors
kitty @ set-colors --all ~/.cache/wal/colors-kitty.conf

# Generate a transparent image for wallpaper
magick -size 1920x1080 xc:transparent "$WALLPAPER_DIR/transparent.png"

