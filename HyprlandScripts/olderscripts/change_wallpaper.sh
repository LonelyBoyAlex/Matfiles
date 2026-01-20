#!/bin/bash

	# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/Hyprpaper"

	# Select a random wallpaper
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

	# Set the wallpaper using swww
swww img "$WALLPAPER" -t any

	# Call the color generation script
$HOME/HyprlandScripts/hywalcolor.sh
$HOME/HyprlandScripts/generate_hyprcolors.sh
$HOME/HyprlandScripts/update_wofi_colors.sh
	#$HOME/HyprlandScripts/dunstcolorsupdater.sh
$HOME/HyprlandScripts/updatemakocolors.sh
$HOME/HyprlandScripts/hyprlockwalpath.sh
# not working - $HOME/HyprlandScripts/logoutmenucolorschanger.sh
   # Reload kitty with new colors
kitty @ set-colors --all ~/.cache/wal/colors-kitty.conf
