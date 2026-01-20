#!/bin/bash

# Handle clicks (Scroll Up/Down)
case $BLOCK_BUTTON in
    4) brightnessctl set +5% ;; # Scroll up: Brightness Up
    5) brightnessctl set 5%- ;; # Scroll down: Brightness Down
esac

# Get Brightness Percentage
# 'm' = machine readable (csv), getting 4th field (percentage with %), removing '%'
# Example output of `brightnessctl -m`:  intel_backlight,backlight,19200,9600,50%
BRIGHTNESS=$(brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}')

# Fallback if empty
if [ -z "$BRIGHTNESS" ]; then BRIGHTNESS=0; fi

# Bar generation (|||||||||)
# Creates 10 bars total. Fills them based on percentage.
BARS=""
for i in {1..10}; do
    if [ $((i * 10)) -le $BRIGHTNESS ]; then 
        BARS="${BARS}|"
    else 
        BARS="${BARS} "
    fi
done

# Output: Icon + Percent + Bar
echo "󰃟  $BRIGHTNESS% [$BARS]"

