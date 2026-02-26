#!/bin/bash

POSITION=$(playerctl position 2>/dev/null)
LENGTH=$(playerctl metadata mpris:length 2>/dev/null)

if [[ -z "$POSITION" || -z "$LENGTH" ]]; then
  echo 0
  exit 0
fi

# Convert microseconds to seconds
LENGTH_SEC=$(echo "$LENGTH / 1000000" | bc)

if [[ "$LENGTH_SEC" -eq 0 ]]; then
  echo 0
  exit 0
fi

PERCENT=$(echo "($POSITION / $LENGTH_SEC) * 100" | bc -l)
printf "%.0f\n" "$PERCENT"
