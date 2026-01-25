#!/bin/bash

WALLPAPER_DIR="$HOME/X11Scripts/wallpapers"
PREVIEW_DIR="$HOME/.cache/wallimg"
mkdir -p "$PREVIEW_DIR"
entries=""
# Collect wallpapers and make previews
for wp in "$WALLPAPER_DIR"/*.{jpg,jpeg,png}; do
  [[ -f "$wp" ]] || continue
  name=$(basename "$wp")
  preview="$PREVIEW_DIR/$name.png"
  # Generate preview if not exists
  if [[ ! -f "$preview" ]]; then
    magick "$wp" -resize 300x300^ -gravity center -extent 300x300 "$preview"
  fi
  entries+="${name}\x00icon\x1f${preview}\n"
done
# Show rofi with previews
CHOICE=$(printf "$entries" | rofi -i -dmenu \
  -config ~/X11Scripts/rofi/themer.rasi \
  -p "🖼 Wallpaper:")
# Exit if nothing chosen
[[ -z "$CHOICE" ]] && exit 0
WALLPAPER="$WALLPAPER_DIR/$CHOICE"
# Set wallpaper via feh
feh --bg-fill "$WALLPAPER"
echo "$WALLPAPER" >~/X11Scripts/currWall
#betterlockscreen -u $(cat X11Scripts/currWall) --fx blur
notify-send "wallpaper updated" "$CHOICE"
