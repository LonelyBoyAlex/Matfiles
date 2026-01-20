#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/Hyprpaper"

# Use Zenity to display a file chooser dialog
WALLPAPER=$(zenity --file-selection --title="Select a Wallpaper" \
  --filename="$WALLPAPER_DIR/" \
  --file-filter="*.png *.jpg *.jpeg" 2>/dev/null)

# Check if a wallpaper was selected
if [[ -z "$WALLPAPER" ]]; then
    notify-send "Pick a wallpaper, dummy!!!" --urgency=low --icon=dialog-warning
    exit 1
fi

# Set the wallpaper using swaybg
#swaybg -i "$WALLPAPER" -m fill &
swww img "$WALLPAPER" --resize crop --transition-type grow --transition-duration 1.5 --transition-fps 60 --transition-pos 0.5,0.96 &
wal -i "$WALLPAPER" -n

# Update Rofi background
WALLPAPER_PATH="$WALLPAPER"  # Use the selected wallpaper path
sed -i "s|background-image: url.*|background-image: url(\"$WALLPAPER_PATH\",width);|" ~/.config/rofi/coloredrofidark.rasi

# Call the color generation scripts
$HOME/HyprlandScripts/generate_hyprcolors.sh
$HOME/HyprlandScripts/hyprlockwalpath.sh
$HOME/HyprlandScripts/change_rofiwall7.sh
$HOME/HyprlandScripts/fuzzelcolors.sh
swaync-client --reload-css
# not working - 
#$HOME/HyprlandScripts/update_wofi_colors.sh
#$HOME/HyprlandScripts/dunstcolorsupdater.sh
#$HOME/HyprlandScripts/updatemakocolors.sh
#$HOME/HyprlandScripts/logoutmenucolorschanger.sh

# Reload kitty with new colors
kitty @ set-colors --all ~/.cache/wal/colors-kitty.conf

# Create a transparent image (optional, as in the original script)
magick -size 1920x1080 xc:transparent /home/papa/Pictures/Hyprpaper/transparent.png
