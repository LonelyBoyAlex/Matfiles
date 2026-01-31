#!/bin/bash

CACHE_FILE="$HOME/.cache/ewwtype.txt"

# Ensure cache directory exists
mkdir -p "$HOME/.cache"

# Kill eww if running
if pgrep -x eww >/dev/null; then
  killall eww
fi

# Function to launch layouts
launch_eww() {
  case "$1" in
  goth)
    eww open-many bar paneltop panelryt panelbot \
      barcornertop barcornerbottom barcornertopryt barcornerbottomryt \
      --config .config/eww.old-goth/
    ;;
  bar)
    eww open bar
    ;;
  baronly)
    eww open-many bar barcornertop barcornerbottom \
      --config ~/.config/eww.fullbar/
    ;;
  *)
    echo "Invalid eww type: $1"
    exit 1
    ;;
  esac
}

# Reload mode → read from cache
if [[ "$1" == "reload" ]]; then
  if [[ ! -f "$CACHE_FILE" ]]; then
    echo "No cached eww type found. Run once with bar/goth/baronly."
    exit 1
  fi

  EWW_TYPE=$(cat "$CACHE_FILE")
  launch_eww "$EWW_TYPE"
  exit 0
fi

# Normal mode → write cache + launch
case "$1" in
goth | bar | baronly)
  echo "$1" >"$CACHE_FILE"
  launch_eww "$1"
  ;;
*)
  echo "Usage: $0 {bar|goth|baronly|reload}"
  exit 1
  ;;
esac
