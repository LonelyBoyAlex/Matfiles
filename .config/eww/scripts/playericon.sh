#!/bin/bash

# Check if playerctl exists
if ! command -v playerctl >/dev/null; then
  echo "󰽷" # music-off fallback
  exit 0
fi

STATUS=$(playerctl status 2>/dev/null)

case "$STATUS" in
Playing)
  echo "" #music IS playing
  ;;
Paused)
  echo ""
  ;;
*)
  echo "󰎊" #nothing playing
  ;;
esac
