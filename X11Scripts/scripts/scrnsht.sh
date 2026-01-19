#!/bin/sh

PICTURES=~/Pictures/Screenshots
[ -d "$PICTURES" ] || mkdir -p "$PICTURES"
DATE=$(date +%Y-%m-%d-%H%M%S)

ROFI_FONT="JetBrains Mono Nerd Font 16"
# Delay in seconds to let rofi close before capture
DELAY=2

CHOOSE=$(printf "    Full screen\n    Active window\n    Select area\n    Copy to clipboard" | rofi -dmenu -p "Screenshot:" -config ~/X11Scripts/rofi/rofi-power.rasi -font "$ROFI_FONT" -theme-str 'window {width: 450px; height: 400px;}')

case "$CHOOSE" in
  "    Full screen")
    scrot -d "$DELAY" "$PICTURES/screenshot-$DATE.png"
    dunstify "SCREENSHOTTED" "screenshot-$DATE.png"
    ;;
  "    Active window")
    scrot -u -d "$DELAY" "$PICTURES/screenshot-$DATE.png"
    dunstify "SCREENSHOTTED" "screenshot-$DATE.png"
    ;;
  "    Select area")
    # For selection, delay is still useful so rofi can close before interactive select starts
    scrot -s -d "$DELAY" "$PICTURES/screenshot-$DATE.png"
    dunstify "SCREENSHOTTED" "screenshot-$DATE.png"
    ;;
  "    Copy to clipboard")
    TMP_IMG="/tmp/screenshot-$DATE.png"
    # Use selection mode; add delay so rofi fully closes before the selection UI
    scrot -s -d "$DELAY" "$TMP_IMG" && xclip -selection clipboard -t image/png -i "$TMP_IMG" && rm -f "$TMP_IMG"
    dunstify "ClipBorad" "screenshot-$DATE.png"
    ;;
  *)
    exit 1
    ;;
esac

