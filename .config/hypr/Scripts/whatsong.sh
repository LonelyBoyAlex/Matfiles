#!/usr/bin/env bash

max=40

status=$(playerctl status 2>/dev/null)
if [ $? -ne 0 ] || [ "$status" = "Stopped" ]; then
  echo "󰽶 Nothing Playing"
  exit 0
fi

title=$(playerctl metadata title 2>/dev/null)
artist=$(playerctl metadata artist 2>/dev/null)

case "$status" in
Playing) icon="" ;;
Paused) icon="" ;;
*) icon="󰽶" ;;
esac

text="$icon $title — $artist"

if [ ${#text} -gt $max ]; then
  echo "${text:0:$((max - 1))}…"
else
  echo "$text"
fi
