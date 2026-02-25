#!/usr/bin/env bash

set -e

THEMES_DIR="$HOME/.config/eww/themes"
EWW_DIR="$HOME/.config/eww"
ROFI_CONFIG="$HOME/.config/rofi/myconfig.rasi"
STATE_FILE="$HOME/.cache/ewwtype.txt"

if [[ "$XDG_CURRENT_DESKTOP" =~ [Nn]iri ]]; then
  ROFI_CONFIG="$HOME/HyprlandScripts/rofistyles/niri_themer.rasi"
fi
# ---------- THEME SELECTION ----------
if [ "$1" = "restore" ]; then
  if [ ! -f "$STATE_FILE" ]; then
    echo "No saved EWW state to restore"
    exit 0
  fi
  THEME="$(cat "$STATE_FILE")"

elif [ -n "$1" ]; then
  THEME="$1"

else
  THEME=$(find "$THEMES_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" |
    sort |
    rofi -dmenu -i -p "EWW Theme" -config "$ROFI_CONFIG")
fi

# Exit if nothing selected
[ -z "$THEME" ] && exit 0

SELECTED_THEME="$THEMES_DIR/$THEME"

# Safety check
if [ ! -d "$SELECTED_THEME" ]; then
  echo "Theme not found: $THEME"
  exit 1
fi

# ---------- SAVE STATE ----------
mkdir -p "$(dirname "$STATE_FILE")"
echo "$THEME" >"$STATE_FILE"

echo "######### LINKING ########"

# Symlink theme files
ln -sf "$SELECTED_THEME"/* "$EWW_DIR/"

# Restart eww cleanly
killall eww 2>/dev/null || true

echo "######### OPENING ########"

# ---------- OPEN WINDOWS ----------
case "$THEME" in
goth)
  eww open-many bar paneltop panelryt panelbot \
    barcornertop barcornerbottom barcornertopryt barcornerbottomryt
  ;;
bar60)
  eww open bar
  ;;
barfull)
  eww open-many bar barcornertop barcornerbottom barcornertopryt barcornerbottomryt
  ;;
goth-top)
  eww open-many bar panelleft panelryt panelbot \
    barcornertop barcornerbottom barcornertopryt barcornerbottomryt
  ;;
topbar | barleft)
  eww open-many bar
  ;;
topbargothic)
  eww open-many bar barcornertop barcornerbottom barcornertopryt barcornerbottomryt
  ;;
*)
  eww open bar
  ;;
esac
