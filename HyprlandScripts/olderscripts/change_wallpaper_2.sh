
#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/Hyprpaper"

# Select a random wallpaper
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Set the wallpaper using swww
swaybg -i "$WALLPAPER" -m fill &
wal -i $WALLPAPER
# Update Rofi background
WALLPAPER_PATH="$WALLPAPER"  # Use the selected wallpaper path
sed -i "s|background-image: url.*|background-image: url(\"$WALLPAPER_PATH\",width);|" ~/.config/rofi/coloredrofidark.rasi

# Call the color generation scripts
$HOME/HyprlandScripts/generate_hyprcolors.sh
$HOME/HyprlandScripts/hyprlockwalpath.sh
$HOME/HyprlandScripts/change_rofiwall7.sh
$HOME/HyprlandScripts/fuzzelcolors.sh
# not working - 
#$HOME/HyprlandScripts/update_wofi_colors.sh
#$HOME/HyprlandScripts/dunstcolorsupdater.sh
#$HOME/HyprlandScripts/updatemakocolors.sh
#$HOME/HyprlandScripts/logoutmenucolorschanger.sh

# Reload kitty with new colors
kitty @ set-colors --all ~/.cache/wal/colors-kitty.conf

magick -size 1920x1080 xc:transparent /home/papa/Pictures/Hyprpaper/transparent.png

