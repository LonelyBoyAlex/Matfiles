#!/bin/bash

# Handle clicks
case $BLOCK_BUTTON in
    1) pavucontrol ;;  # Left click: Open mixer
    3) pactl set-sink-mute @DEFAULT_SINK@ toggle ;; # Right click: Mute
    4) pactl set-sink-volume @DEFAULT_SINK@ +5% ;; # Scroll up: Vol Up
    5) pactl set-sink-volume @DEFAULT_SINK@ -5% ;; # Scroll down: Vol Down
esac

# Get Volume & Mute Status
VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1 | tr -d '%')
MUTE=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -o "yes")

# Icon logic
if [ "$MUTE" = "yes" ]; then
    echo "󰝟 MUTE [--- ---]"
    exit
fi

if [ -z "$VOL" ]; then VOL=0; fi

# Bar generation (|||||||||)
BARS=""
for i in {1..10}; do
    if [ $((i * 10)) -le $VOL ]; then BARS="${BARS}|"; else BARS="${BARS} "; fi
done

# Output
echo "  $VOL% [$BARS]"

