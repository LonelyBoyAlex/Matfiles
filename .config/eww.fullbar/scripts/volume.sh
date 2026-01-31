#!/usr/bin/env bash

# Define an array of volume icons (customize as needed)
icons=( "" "" "" "󰕾" "" )
# icons=( "🔈" "🔉" "🔊" "📢" "📣" )

# Get current volume/mute status once
out=$(pamixer --get-volume-human)

case "$1" in
  get)
    if [ "$out" = "muted" ]; then
      echo 0
    else
      echo "${out%\%}"
    fi
    ;;
  set)
    pamixer --set-volume "$2"
    ;;
  icon)
    if [ "$out" = "muted" ]; then
      icon=""  # Muted icon
    else
      vol=${out%\%}
      if (( vol == 0 )); then
        icon=""
        # icon="🔇"
      elif (( vol <= 20 )); then
        icon="${icons[0]}"
      elif (( vol <= 40 )); then
        icon="${icons[1]}"
      elif (( vol <= 60 )); then
        icon="${icons[2]}"
      elif (( vol <= 80 )); then
        icon="${icons[3]}"
      else
        icon="${icons[4]}"
      fi
    fi
    echo "$icon"
    ;;
  *)
    echo "Usage: $0 {get|set <value>|icon}"
    exit 1
    ;;
esac
