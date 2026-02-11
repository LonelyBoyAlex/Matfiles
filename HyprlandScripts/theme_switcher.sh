#!/bin/bash

THEME_DIR="$HOME/.config/themes"
ACTIVE_LINK="$THEME_DIR/active"
DEFAULT_HYTHEME="$THEME_DIR/default/hytheme.conf"

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

echo "-----------------------------"
echo "++ Current WM: $WINDOWMAN ++"
echo "-----------------------------"

entries=""

# Collect all valid themes with their preview PNG
for dir in "$THEME_DIR"/*/; do
  theme=$(basename "$dir")

  # Skip special folders
  [[ "$theme" == "active" || "$theme" == "default" ]] && continue

  preview="$THEME_DIR/$theme.png"

  if [[ -f "$preview" ]]; then
    entries+="${theme}\x00icon\x1f${preview}\n"
  else
    entries+="${theme}\n" # fallback: text only
  fi
done

# Show Rofi with preview icons
# Pick rofi config depending on WM
if [[ $WINDOWMAN == "Hyprland" ]]; then
  CHOICE=$(printf "$entries" | rofi -i -dmenu \
    -config ~/HyprlandScripts/rofistyles/hypr_themer.rasi \
    -p "🖼 Wallpaper:" -show-icons)
  #-config ~/HyprlandScripts/rofistyles/themer.rasi \
elif [[ $WINDOWMAN == "Niri" ]]; then
  CHOICE=$(printf "$entries" | rofi -i -dmenu \
    -config ~/HyprlandScripts/rofistyles/niri_themer.rasi \
    -p "🖼 Wallpaper:" -show-icons)
elif [[ $WINDOWMAN == "mango" ]]; then
  CHOICE=$(printf "$entries" | rofi -i -dmenu \
    -config ~/HyprlandScripts/rofistyles/mango_themer.rasi \
    -p "🖼 Wallpaper:" -show-icons)
  #-config ~/HyprlandScripts/mango_themer.rasi \
elif [[ $WINDOWMAN == "i3" ]]; then
  CHOICE=$(printf "$entries" | rofi -i -dmenu \
    -config ~/HyprlandScripts/rofistyles/scrsht.rasi \
    -p "🖼 Wallpaper:" -show-icons)
else
  CHOICE=$(printf "$entries" | rofi -i -dmenu \
    -p "🖼 Wallpaper:")
fi
# If nothing chosen, exit
[[ -z "$CHOICE" ]] && exit 0

SELECTED="$THEME_DIR/$CHOICE"

echo "--------- linking ---------"

# Switch active theme symlink
rm -rf "$ACTIVE_LINK"
ln -s "$SELECTED" "$ACTIVE_LINK"

# If no hytheme.conf in theme, symlink default one
[[ ! -f "$ACTIVE_LINK/hytheme.conf" && -f "$DEFAULT_HYTHEME" ]] &&
  ln -sf "$DEFAULT_HYTHEME" "$ACTIVE_LINK/hytheme.conf"

# Wait until wallpapers dir appears
for i in {1..20}; do
  [[ -d "$ACTIVE_LINK/wallpapers" ]] && break
  sleep 0.05
done

# Attempt to restore last-used wallpaper
WALLPAPER_DIR="$ACTIVE_LINK/wallpapers"
CURR_WALL=$(find "$WALLPAPER_DIR" -maxdepth 1 -type l -name "current" | head -n 1)

if [[ -n "$CURR_WALL" && -f "$CURR_WALL" ]]; then
  echo "🖼️ Restoring wallpaper from $CURR_WALL"

  if [[ $WINDOWMAN == "i3" ]]; then
    feh --bg-fill "$CURR_WALL"
  else
    {
      swww img "$CURR_WALL" --resize crop \
        --transition-type wipe \
        --transition-duration 2.5 \
        --transition-fps 60 \
        --transition-angle 135
    }
  fi
  # Lowercase the choice for case-insensitive matching
  CHOICE_LOWER=$(echo "$CHOICE" | tr '[:upper:]' '[:lower:]')

  case "$CHOICE_LOWER" in
  mono)
    matugen image "$(readlink .config/themes/active/wallpapers/current)" -t scheme-monochrome
    ;;
  # Add more lowercase theme keys here in the future
  *)
    matugen image "$(readlink .config/themes/active/wallpapers/current)"
    ;;
  esac

  ln -sf "$ACTIVE_LINK/wallpapers/$(basename $(readlink $CURR_WALL))" ~/.cache/currwall
  ln -sf "$ACTIVE_LINK/wallpapers/$(basename $(readlink $CURR_WALL))" ~/.cache/currwall.png
  if pgrep -x swaync >/dev/null; then
    swaync-client --reload-css
  fi
else
  echo "⚠️  No current wallpaper symlink found in $WALLPAPER_DIR"
  ~/HyprlandScripts/wallpaper.sh
fi

# Reload Hyprland just in case
if [[ $WINDOWMAN == "Hyprland" ]]; then
  hyprctl reload
fi

if pgrep -x eww >/dev/null; then
  #~/HyprlandScripts/ewwStarter.sh reload
  ~/HyprlandScripts/ewwTheme.sh restore
fi

~/HyprlandScripts/ChromiumPywal/generate-theme.sh

notify-send "🎨 Theme switched to '$CHOICE'"
