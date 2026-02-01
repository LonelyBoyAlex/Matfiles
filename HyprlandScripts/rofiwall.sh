#!/bin/bash

WALLPAPER_DIR="$HOME/.config/themes/active/wallpapers"
PREVIEW_DIR="$HOME/.cache/wallimg"

## Detect current Wayland compositor (Hyprland or Niri)
if [[ "$XDG_CURRENT_DESKTOP" =~ [Hh]yprland ]]; then
  WINDOWMAN="Hyprland"
elif [[ "$XDG_CURRENT_DESKTOP" =~ [Nn]iri ]]; then
  WINDOWMAN="Niri"
elif [[ "$XDG_CURRENT_DESKTOP" =~ [Mm]ango ]]; then
  WINDOWMAN="mango"
elif [[ "$XDG_CURRENT_DESKTOP" =~ [Ii]3 ]]; then
  WINDOWMAN="i3"
else
  # Fallback check (just in case)
  if pgrep -x hyprland >/dev/null; then
    WINDOWMAN="Hyprland"
  elif pgrep -x niri >/dev/null; then
    WINDOWMAN="Niri"
  else
    WINDOWMAN="Unknown"
  fi
fi

echo "#############################"
echo "!! Current WM: $WINDOWMAN" !!
echo "#############################"

mkdir -p "$PREVIEW_DIR"

# Pick correct ImageMagick command (IM7=magick, IM6=convert)
if command -v magick >/dev/null 2>&1; then
  IM_CMD="magick"
else
  IM_CMD="convert"
fi

entries=""

# Collect wallpapers and make previews
for wp in "$WALLPAPER_DIR"/*.{jpg,jpeg,png}; do
  [[ -f "$wp" ]] || continue

  name=$(basename "$wp")
  preview="$PREVIEW_DIR/$name.png"

  # Generate preview if not exists
  if [[ ! -f "$preview" ]]; then
    $IM_CMD "$wp" -resize 300x300^ -gravity center -extent 300x300 "$preview"
  fi

  entries+="${name}\x00icon\x1f${preview}\n"
done

# Show rofi with previews
# Pick rofi config depending on WM
if [[ $WINDOWMAN == "Hyprland" ]]; then
  CHOICE=$(printf "$entries" | rofi -i -dmenu \
    -config ~/HyprlandScripts/rofistyles/hypr_themer.rasi \
    -p "🖼 Wallpaper:" -show-icons)
elif [[ $WINDOWMAN == "Niri" ]]; then
  CHOICE=$(printf "$entries" | rofi -i -dmenu \
    -config ~/HyprlandScripts/rofistyles/niri_themer.rasi \
    -p "🖼 Wallpaper:" -show-icons)
elif [[ $WINDOWMAN == "mango" ]]; then
  CHOICE=$(printf "$entries" | rofi -i -dmenu \
    -config ~/HyprlandScripts/rofistyles/mango_themer.rasi \
    -p "🖼 Wallpaper:" -show-icons)
elif [[ $WINDOWMAN == "i3" ]]; then
  CHOICE=$(printf "$entries" | rofi -i -dmenu \
    -config ~/HyprlandScripts/rofistyles/scrsht.rasi \
    -p "🖼 Wallpaper:")
else
  CHOICE=$(printf "$entries" | rofi -i -dmenu \
    -p "🖼 Wallpaper:")
fi
# Exit if nothing chosen
[[ -z "$CHOICE" ]] && exit 0

echo "+++ $CHOICE +++"

WALLPAPER="$WALLPAPER_DIR/$CHOICE"

# Set wallpaper via swww (random transition position is default)
if pgrep -x eww >/dev/null; then
  swww img "$WALLPAPER" --resize crop \
    --transition-type grow \
    --transition-pos 0.03,0.5 \
    --transition-duration 4.5 \
    --transition-step 255 \
    --transition-fps 60
  # Symlink current wallpaper for other tools
  ln -sf "$WALLPAPER" ~/.cache/currwall
  ln -sf "$WALLPAPER" ~/.cache/currwall.png
  ~/HyprlandScripts/ewwStarter.sh reload
else
  if [[ $WINDOWMAN == "i3" ]]; then
    echo "##################"
    echo "!!  i3 works    !!"
    echo "##################"
    feh --bg-fill "$WALLPAPER"
    echo "$WALLPAPER" >~/X11Scripts/currWall
    betterlockscreen -u $(cat X11Scripts/currWall) --fx blur
    notify-send "wallpaper updated" "$CHOICE"

  else
    {
      swww img "$WALLPAPER" --resize crop \
        --transition-type any \
        --transition-duration 3.7 \
        --transition-step 255 \
        --transition-fps 60
      # Symlink current wallpaper for other tools
      ln -sf "$WALLPAPER" ~/.cache/currwall
      ln -sf "$WALLPAPER" ~/.cache/currwall.png
    }
  fi
fi

# Generate colors with pywal
echo "###########################"
echo "!!    matugen colorgen   !!"
echo "###########################"
matugen image "$WALLPAPER"

# Reload UI components
if pgrep -x swaync >/dev/null; then
  echo "###########################"
  echo "!!    swaync   reload    !!"
  echo "###########################"

  swaync-client --reload-css
fi

# === Auto-generate theme preview ===
echo "########################"
echo "!! preview generation !!"
echo "########################"

ACTIVE_THEME_DIR="$HOME/.config/themes/active"
ACTIVE_THEME_NAME=$(basename "$(readlink "$ACTIVE_THEME_DIR")")
PREVIEW_PATH="$HOME/.config/themes/${ACTIVE_THEME_NAME}.png"

# Resolve real theme folder from symlink
THEME_DIR="$(readlink -f "$ACTIVE_THEME_DIR")"
WALL_NAME="$(basename "$WALLPAPER")"
TARGET_WALL="$THEME_DIR/wallpapers/$WALL_NAME"
SYMLINK_PATH="$THEME_DIR/wallpapers/current"

# Symlink current wallpaper inside theme folder
if [[ -f "$TARGET_WALL" ]]; then
  ln -sf "$TARGET_WALL" "$SYMLINK_PATH"
  echo "🪄 Symlinked current → $WALL_NAME"
else
  echo "⚠️ Wallpaper $WALL_NAME not found in $THEME_DIR/wallpapers/"
fi

# Generate/update theme preview
if [[ -f "$WALLPAPER" ]]; then
  $IM_CMD "$WALLPAPER" -resize 300x300^ -gravity center -extent 300x300 "$PREVIEW_PATH"
  echo "🖼️ Generated preview: $PREVIEW_PATH"
fi

# relaunch eww
#if pgrep -x eww >/dev/null; then
#  ~/HyprlandScripts/ewwStarter.sh bar
#fi

magick "$WALLPAPER" -blur 10x20 ~/.cache/wallblurred.png

if [[ "${XDG_CURRENT_DESKTOP,,}" == "niri" ]]; then
  ##killall swaybg 2>/dev/null
  "$HOME/.config/niri/scripts/overviewbackground.sh"
  echo "##################"
  echo "blurred wall LOADED..."
  echo "##################"
fi

#themecord -p
#~/HyprlandScripts/ChromiumPywal/generate-theme.sh
#wal-telegram -w -g -r
