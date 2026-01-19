
#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="/home/papa/Pictures/Hyprpaper"

# List all image files in the directory
wallpapers=($(ls "$WALLPAPER_DIR" | grep -E "\.(jpg|jpeg|png)$"))
if [ ${#wallpapers[@]} -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Generate a preview for each wallpaper
preview_images=()
for wallpaper in "${wallpapers[@]}"; do
    preview_images+=("$WALLPAPER_DIR/$wallpaper")
done

# Use rofi to select a wallpaper with preview
selected=$(printf "%s\n" "${wallpapers[@]}" | rofi -dmenu -i -p "Select Wallpaper" \
    -theme-str 'listview { lines: 10; }' \
    -modi "window,run,ssh" \
    -preview-command 'echo "cat $1"; convert "$1" -resize 128x128\> "$1".png; cat "$1".png' \
    -preview-window 'up' )

# Exit if no wallpaper is selected
if [ -z "$selected" ]; then
    echo "No wallpaper selected."
    exit 0
fi

# Full path to the selected wallpaper
wallpaper_path="$WALLPAPER_DIR/$selected"

# Set the wallpaper using swaybg
swaybg -i "$wallpaper_path" -m fill &

# Optionally, you can use `wal` if you want to set colors
wal -i "$wallpaper_path" &

# Reload Sway (you can reload specific components if needed)
swaymsg reload &

echo "Wallpaper set to $wallpaper_path"
