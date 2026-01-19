#!/bin/sh

PICTURES=~/Pictures/Screenshots
[ -d "$PICTURES" ] || mkdir -p "$PICTURES"
DATE=$(date +%Y-%m-%d-%H%M%S)

ROFI_FONT="Hermit Nerd Font Propo 16"
# Delay in seconds to let rofi close before capture
DELAY=1

CHOOSE=$(printf "Full screen\nActive window\nSelect area\nCopy to clipboard" | rofi -dmenu -p "Screenshot:" -config ~/X11Scripts/rofi/config.rasi -font "$ROFI_FONT" -theme-str 'window {width: 350px; height: 300px;}')
#CHOOSE=$(printf "Full screen\nActive window\nSelect area\nCopy to clipboard" | rofi -dmenu -p "Screenshot:" -config ~/X11Scripts/rofi/pmenu.rasi -font "$ROFI_FONT" -theme-str 'window {width: 350px; height: 300px;}')

case "$CHOOSE" in
  "Full screen")
    scrot -d "$DELAY" "$PICTURES/screenshot-$DATE.png"
    ;;
  "Active window")
    scrot -u -d "$DELAY" "$PICTURES/screenshot-$DATE.png"
    ;;
  "Select area")
    # For selection, delay is still useful so rofi can close before interactive select starts
    scrot -s -d "$DELAY" "$PICTURES/screenshot-$DATE.png"
    ;;
  "Copy to clipboard")
    TMP_IMG="/tmp/screenshot-$DATE.png"
    # Use selection mode; add delay so rofi fully closes before the selection UI
    scrot -s -d "$DELAY" "$TMP_IMG" && xclip -selection clipboard -t image/png -i "$TMP_IMG" && rm -f "$TMP_IMG"
    ;;
  *)
    exit 1
    ;;
esac

