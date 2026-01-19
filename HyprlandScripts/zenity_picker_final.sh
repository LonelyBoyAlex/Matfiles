##!/bin/bash

# Directory containing wallpapers
#WALLPAPER_DIR="$HOME/Pictures/Hyprpaper"
WALLPAPER_DIR="$HOME/.config/themes/active/wallpapers"

# Use Zenity to display a file chooser dialog
WALLPAPER=$(zenity --file-selection --title="Select a Wallpaper" \
  --filename="$WALLPAPER_DIR/" \
  --file-filter="*.png *.jpg *.jpeg" 2>/dev/null)

# Check if a wallpaper was selected
if [[ -z "$WALLPAPER" ]]; then
    notify-send "Pick a wallpaper, dummy!!!" --urgency=low --icon=dialog-warning
    exit 1
fi

# Mode cache file
CACHE_FILE="$HOME/.cache/mode"


# Apply the chosen mode and save to cache
wal -i "$WALLPAPER" -n
#gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
#gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
#echo "dark" > "$CACHE_FILE"

# Set wallpaper using swww
swww img "$WALLPAPER" --resize crop --transition-type any --transition-duration 1.5 --transition-fps 60

swaync-client --reload-css

## getting wallpaper to cache to get rofi image
#cp $(cat ~/.cache/wal/wal) ~/.cache/currwall
ln -sf "$WALLPAPER" ~/.cache/currwall
ln -sf "$WALLPAPER" ~/.cache/currwall.png

# === Auto-generate theme preview ===

# Path to current theme and preview
ACTIVE_THEME_DIR="$HOME/.config/themes/active"
ACTIVE_THEME_NAME=$(basename "$(readlink "$ACTIVE_THEME_DIR")")
PREVIEW_PATH="$HOME/.config/themes/${ACTIVE_THEME_NAME}.png"

# Use current wallpaper as preview (resized)
if [[ -f "$WALLPAPER" ]]; then
    magick "$WALLPAPER" -resize 300x300^ -gravity center -extent 300x300 "$PREVIEW_PATH"
    echo "🖼️ Generated preview: $PREVIEW_PATH"
fi


# ------ currentwall link generator for wallpaper restore on theme change -------
# Resolve real theme folder from symlink
THEME_DIR="$(readlink -f "$HOME/.config/themes/active")"
WALL_NAME="$(basename "$WALLPAPER")"
#EXT="${WALL_NAME##*.}"

# Full path to the wallpaper inside the real theme folder
TARGET_WALL="$THEME_DIR/wallpapers/$WALL_NAME"
SYMLINK_PATH="$THEME_DIR/wallpapers/current"

# Only create symlink if the target exists
if [[ -f "$TARGET_WALL" ]]; then
    ln -sf "$TARGET_WALL" "$SYMLINK_PATH"
    echo "🪄 Symlinked current → $WALL_NAME"
else
    echo "⚠️  Wallpaper $WALL_NAME not found in $THEME_DIR/wallpapers/"
fi


~/HyprlandScripts/ChromiumPywal/generate-theme.sh
