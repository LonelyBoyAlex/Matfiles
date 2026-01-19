#!/bin/bash
# Waybar gaps updater - integrated with Hyprland gaps

# Path to Waybar config
CONFIG="$HOME/.config/waybar/config.jsonc"

# Get the current gaps_out from Hyprland (first number only)
GAP=$(hyprctl getoption general:gaps_out | awk '/custom type:/ {print $3}')

# Ensure we got a valid number
if [[ -z "$GAP" ]]; then
    echo "Error: Could not read gaps_out from Hyprland."
    exit 1
fi

# Update margin-left and margin-right in config.jsonc
sed -i "s/\"margin-left\": [0-9]\+\,/\"margin-left\": ${GAP},/" "$CONFIG"
sed -i "s/\"margin-right\": [0-9]\+\,/\"margin-right\": ${GAP},/" "$CONFIG"

# Reload Waybar if running, otherwise start it
if pgrep -x "waybar" >/dev/null; then
    pkill -USR2 waybar
else
    nohup waybar >/dev/null 2>&1 &
fi
