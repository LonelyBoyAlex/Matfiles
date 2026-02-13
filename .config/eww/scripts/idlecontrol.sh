#!/usr/bin/env bash

ICON_ENABLED="󰒲"  # idle working normally
ICON_DISABLED="󰒳" # idle inhibited

start_idle() {
  hypridle >/dev/null 2>&1 &
}

stop_idle() {
  pkill -x hypridle
}

is_running() {
  pgrep -x hypridle >/dev/null
}

case "$1" in
status)
  if is_running; then
    echo "$ICON_ENABLED"
  else
    echo "$ICON_DISABLED"
  fi
  ;;
toggle)
  if is_running; then
    stop_idle
  else
    start_idle
  fi
  ;;
*)
  echo "$ICON_DISABLED"
  ;;
esac
