#!/bin/bash

NOTIFY_CMD="notify-send"
NOTIFY_ID=9998
ICON="display-brightness-symbolic"

show_notification() {
  local brightness=$1
  $NOTIFY_CMD -r "$NOTIFY_ID" \
    -h int:value:"$brightness" \
    -h string:synchronous:brightness \
    -i "$ICON" "Brightness: $brightness%"
}

case "${1:-status}" in
up)
  output=$(brightnessctl set +5%)
  brightness=$(echo "$output" | grep -o '[0-9]\+%' | sed 's/%//')
  show_notification "$brightness"
  ;;
down)
  output=$(brightnessctl set 5%-)
  brightness=$(echo "$output" | grep -o '[0-9]\+%' | sed 's/%//')
  show_notification "$brightness"
  ;;
status | *)
  brightness=$(brightnessctl get | awk '{print int($1*100/7500)}')
  show_notification "$brightness"
  ;;
esac
