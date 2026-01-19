#!/bin/bash

# Theme directory
THEME_DIR="$HOME/.config/waybar/themes"
WAYBAR_CONFIG="$HOME/.config/waybar/config.jsonc"
WAYBAR_STYLE="$HOME/.config/waybar/style.css"

# Get list of available themes (directory names)
themes=$(ls "$THEME_DIR")

# Use rofi to select one
#chosen=$(echo "$themes" | rofi -i -font "JetBrains Mono Nerd Font 16" -dmenu -p "Select Waybar Theme")
#chosen=$(echo "$themes" | rofi -config ~/testconfigs/thewe.rasi -dmenu -p "Select Waybar Theme")
chosen=$(echo "$themes" | rofi -i -config ~/HyprlandScripts/thewaybar.rasi -dmenu -p "Select Waybar Theme")

# If a theme was selected
if [ -n "$chosen" ]; then
    theme_path="$THEME_DIR/$chosen"

    # Symlink the theme config and style
    ln -sf "$theme_path/config.jsonc" "$WAYBAR_CONFIG"
    ln -sf "$theme_path/style.css" "$WAYBAR_STYLE"

    # Reload Waybar
    #pkill waybar && waybar &
    sh -c 'killall waybar 2>/dev/null; waybar 2>/dev/null &'
#    HyprlandScripts/waybargaps.sh
fi

