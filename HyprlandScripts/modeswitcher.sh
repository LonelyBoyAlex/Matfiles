#!/bin/bash

# Get the current mode (fallback to Dark if missing)
MODE_FILE="$HOME/.cache/mode"
if [[ -f "$MODE_FILE" ]]; then
    CURRENT_MODE=$(cat "$MODE_FILE")
else
    CURRENT_MODE="Dark"
fi

# Rofi selection
#CHOICE=$(printf "Dark\nLight" | rofi -font "mono 18" -dmenu -p "Choose theme mode:")
CHOICE=$((printf "Light\x00icon\x1f~/.config/rofi/icons/light.svg\nDark\x00icon\x1f~/.config/rofi/icons/dark.svg") | rofi -dmenu -config ~/HyprlandScripts/moder.rasi -p "Choose theme mode:" -show-icons)
[[ -z "$CHOICE" ]] && exit

# Wallpaper from pywal cache
WALLPAPER=$(cat "$HOME/.cache/wal/wal")

# Theme setup
if [[ "$CHOICE" == "Light" ]]; then
    wal -i "$WALLPAPER" -n -l
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
    spicetify config current_theme Matte color_scheme Porcelain
    echo "Light" > "$MODE_FILE"
else
    wal -i "$WALLPAPER" -n
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    spicetify config current_theme Sleek color_scheme Ultrablack
    echo "Dark" > "$MODE_FILE"
fi

# Update rofi theme import line based on mode
sed -i "s|@import \".*colors-rofi-.*\.rasi\"|@import \"~/.cache/wal/colors-rofi-${CHOICE,,}.rasi\"|" "$HOME/.config/rofi/myconfig.rasi"

# Spice the spot
 spicetify apply

# Restart waybar quietly
pkill waybar && waybar > /dev/null 2>&1 &
