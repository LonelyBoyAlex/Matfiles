#!/usr/bin/env bash

icons=( "" "" "" "" "󰽢" )

case "$1" in
  get)
    brightness=$(brightnessctl get)
    max_brightness=$(brightnessctl max)
    percent=$(( brightness * 100 / max_brightness ))
    echo "$percent"
    ;;
  set)
    brightnessctl set "$2%"
    ;;
  icon)
    brightness=$(brightnessctl get)
    max_brightness=$(brightnessctl max)
    percent=$(( brightness * 100 / max_brightness ))
    if (( percent == 0 )); then
      icon=""
    elif (( percent <= 20 )); then
      icon="${icons[0]}"
    elif (( percent <= 40 )); then
      icon="${icons[1]}"
    elif (( percent <= 60 )); then
      icon="${icons[2]}"
    elif (( percent <= 80 )); then
      icon="${icons[3]}"
    else
      icon="${icons[4]}"
    fi
    echo "$icon"
    ;;
  *)
    echo "Usage: $0 {get|set <value>|icon}"
    exit 1
    ;;
esac
