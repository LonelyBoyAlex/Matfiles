#!/bin/bash

#WALLPAPER_DIR="$HOME/Pictures/Hyprpaper"
WALLPAPER_DIR="$HOME/.config/themes/active/wallpapers"

if pgrep -x eww >/dev/null; then
  WAYBAR_CFG=""
else
  WAYBAR_CFG="$HOME/.config/waybar/config.jsonc"
fi

MODE_CACHE="$HOME/.cache/mode"

# Random wallpaper selection
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
echo "🖼️  Setting wallpaper: $WALLPAPER"

# Get Waybar position
#WAYBARPOS=$(grep -oP '"position":\s*"\K(top|bottom)' "$WAYBAR_CFG")
#TRANS_POS="0.5,0.965"  # default for top
#[ "$WAYBARPOS" == "bottom" ] && TRANS_POS="0.5,0.035"

WAYBARPOS=$(grep -oP '"position":\s*"\K(top|bottom|left|right)' "$WAYBAR_CFG")

# Default transition position: center
TRANS_POS="0.5,0.5"

case "$WAYBARPOS" in
    top)
        TRANS_POS="0.5,0.965"
        ;;
    bottom)
        TRANS_POS="0.5,0.035"
        ;;
    left)
        TRANS_POS="0.035,0.5"
        ;;
    right)
        TRANS_POS="0.965,0.5"
        ;;
esac

# Set wallpaper via swww
swww img "$WALLPAPER" --resize crop \
  --transition-type outer \
  --transition-duration 2.5 \
  --transition-fps 60 \
  --transition-pos "$TRANS_POS"

# Set dark mode and generate colors
wal -i "$WALLPAPER" -n
matugen image "$WALLPAPER"
#gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
#gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
#echo "Dark" > "$MODE_CACHE"

# Symlink current wallpaper for other tools
ln -sf "$WALLPAPER" ~/.cache/currwall
ln -sf "$WALLPAPER" ~/.cache/currwall.png

# Reload UI components
swaync-client --reload-css


# === Auto-generate theme preview ===
# Path to current theme and preview
ACTIVE_THEME_DIR="$HOME/.config/themes/active"
ACTIVE_THEME_NAME=$(basename "$(readlink "$ACTIVE_THEME_DIR")")
PREVIEW_PATH="$HOME/.config/themes/${ACTIVE_THEME_NAME}.png"


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


# Use current wallpaper as preview (resized)
if [[ -f "$WALLPAPER" ]]; then
    # magick "$WALLPAPER" -resize 720x720 "$PREVIEW_PATH"
    magick "$WALLPAPER" -resize 300x300^ -gravity center -extent 300x300 "$PREVIEW_PATH"
    echo "🖼️ Generated preview: $PREVIEW_PATH"
fi

if pgrep -x eww >/dev/null; then
    ~/HyprlandScripts/ewwStarter.sh bar
fi

magick "$WALLPAPER" -blur 10x20 ~/.cache/wallblurred.png

if [[ "${XDG_CURRENT_DESKTOP,,}" == "niri" ]]; then
    killall swaybg 2>/dev/null
    "$HOME/.config/niri/scripts/overviewbackground.sh"
    echo "blurred wall LOADED..."
fi

themecord -p
~/HyprlandScripts/ChromiumPywal/generate-theme.sh
wal-telegram -w
