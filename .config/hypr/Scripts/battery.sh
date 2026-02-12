#!/usr/bin/env bash

bat=$(ls /sys/class/power_supply | grep BAT | head -n1)
[ -z "$bat" ] && exit 0

capacity=$(cat /sys/class/power_supply/$bat/capacity)
status=$(cat /sys/class/power_supply/$bat/status)

if [ "$status" != "Discharging" ]; then
  if [ "$capacity" -ge 95 ]; then
    icon="󰠠"
  else
    icon="󱐌"
  fi
else
  if [ "$capacity" -ge 95 ]; then
    icon="󰁹"
  elif [ "$capacity" -ge 80 ]; then
    icon="󰂁"
  elif [ "$capacity" -ge 60 ]; then
    icon="󰁿"
  elif [ "$capacity" -ge 40 ]; then
    icon="󰁽"
  elif [ "$capacity" -ge 20 ]; then
    icon="󰁻"
  else
    icon="󰂃"
  fi
fi

echo "$icon $capacity%"
