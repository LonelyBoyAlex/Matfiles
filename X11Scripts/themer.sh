#!/usr/bin/env bash

# Set working directories
dir="$HOME/X11Scripts"
theme_dir="$HOME/X11Scripts/themes"
dunst_conf_dir="$HOME/.config/dunst/dunstrc.d"
wal_cmd=""

# --- 1. SELECT THEME (PIPED DIRECTLY TO ROFI) ---
# We run the loop inside a subshell and pipe output directly to rofi
# This avoids string formatting issues with null bytes
theme=$(
  for direc in "$theme_dir"/*/; do
    theme_name=$(basename "$direc")

    # FIX: Check strictly case-insensitive to ensure "Thumbnails" is skipped
    if [[ "${theme_name,,}" == "thumbnails" ]]; then
      continue
    fi

    # Path to the thumbnail image
    preview="$theme_dir/thumbnails/$theme_name.png"

    if [[ -f "$preview" ]]; then
      # FIX: Use printf with \x00 for the null byte. Safer than echo.
      # Format: Name + Null + icon + UnitSeparator + Path + Newline
      printf "%s\x00icon\x1f%s\n" "$theme_name" "$preview"
    else
      printf "%s\n" "$theme_name"
    fi
  done | rofi -dmenu -i -theme "$dir/rofi/themer.rasi" -p "Select theme: " -show-icons
)

# Exit if no theme selected or invalid directory
[ -z "$theme" ] || [ ! -d "$theme_dir/$theme" ] && exit 1

# --- 2. WALLPAPER SYMLINK ---
# Only create symlink if theme has wallpapers folder
[ -d "$theme_dir/$theme/wallpapers" ] || {
  notify-send "No wallpapers in $theme"
  exit 1
}

# 'ln -sfn' forces the link update cleanly
ln -sfn "$theme_dir/$theme/wallpapers" "$dir/wallpapers"

# --- 3. COPY CONFIGS (EXCLUDING WALLPAPERS) ---
rsync -av --exclude='wallpapers/' "$theme_dir/$theme/" "$dir/"
cp -f X11Scripts/colors/colors-polybar ~/.config/bspwm/

# --- 4. DUNST CONFIG SYMLINK ---
mkdir -p "$dunst_conf_dir"

if [ -f "$theme_dir/$theme/colors/zdunstcolors.conf" ]; then
  ln -sf "$theme_dir/$theme/colors/zdunstcolors.conf" "$dunst_conf_dir/zdunstcolors.conf"

  # Reload dunst
  pgrep -x dunst >/dev/null && killall dunst
  dunst &
else
  notify-send "Warning: No zdunstcolors.conf found for $theme"
fi

# --- 4.2 qtile CONFIG SYMLINK ---
if [[ "${XDG_SESSION_DESKTOP,,}" == "qtile" ]]; then
  mkdir -p "$HOME/.config/qtile"

  if [ -f "$theme_dir/$theme/colors/colors.py" ]; then
    ln -sf "$dir/colors/colors.py" "$HOME/.config/qtile/colors.py"
    qtile cmd-obj -o cmd -f reload_config
  else
    notify-send "Warning: No COLORS.PY found for $theme"
  fi
fi

# --- 5. WAL THEME LOGIC ---
case "$theme" in
"Everforest")
  bspc config normal_border_color "#2E383C"
  bspc config focused_border_color "#A7C080"
  ;;
  #    "everREst")
  #        ;;
"MonoBlack")
  bspc config normal_border_color "#2F2F2F"
  bspc config focused_border_color "#FFFFFF"
  ;;
"Nord")
  bspc config normal_border_color "#434C5E"
  bspc config focused_border_color "#8fbcbb"
  ;;
"Tokyonight")
  bspc config normal_border_color "#24283b"
  bspc config focused_border_color "#bb9af7"
  ;;
"Rosepine")
  bspc config normal_border_color "#232136"
  bspc config focused_border_color "#ebbcba"
  ;;
"Gruvbox")
  bspc config normal_border_color "#32302f"
  bspc config focused_border_color "#b57614"
  ;;
*)
  #        notify-send "No wal theme mapped for '$theme'" && exit 1
  ;;
esac

#eval "$wal_cmd"
~/X11Scripts/xterm-theme.sh

# --- 6. APPLY WALLPAPER & SAVE STATE ---
$HOME/X11Scripts/wallpaper.sh random

polybar-msg cmd restart

notify-send "Theme '$theme' applied!"
echo "$theme" >"$dir/current_theme"
