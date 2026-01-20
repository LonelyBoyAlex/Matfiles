#!/bin/bash

# Define paths
wal_colors="$HOME/.cache/wal/colors"
dunstrc="$HOME/.config/dunst/dunstrc"

# Extract colors from the wal colors file
bg_low=$(sed -n '1p' "$wal_colors")     # Background for low urgency
fg_low=$(sed -n '8p' "$wal_colors")     # Foreground for low urgency

bg_normal=$(sed -n '2p' "$wal_colors")  # Background for normal urgency
fg_normal=$(sed -n '7p' "$wal_colors")  # Foreground for normal urgency

bg_critical=$(sed -n '3p' "$wal_colors")  # Background for critical urgency
fg_critical=$(sed -n '6p' "$wal_colors")  # Foreground for critical urgency

# Backup the original dunstrc
cp "$dunstrc" "$dunstrc.bak"

# Use sed to replace the colors in the dunstrc
sed -i "s/^background = .*$/background = \"$bg_low\"/g" "$dunstrc"
sed -i "s/^foreground = .*$/foreground = \"$fg_low\"/g" "$dunstrc"

sed -i "/\[urgency_normal\]/,/^\[/ s/^background = .*$/background = \"$bg_normal\"/" "$dunstrc"
sed -i "/\[urgency_normal\]/,/^\[/ s/^foreground = .*$/foreground = \"$fg_normal\"/" "$dunstrc"

sed -i "/\[urgency_critical\]/,/^\[/ s/^background = .*$/background = \"$bg_critical\"/" "$dunstrc"
sed -i "/\[urgency_critical\]/,/^\[/ s/^foreground = .*$/foreground = \"$fg_critical\"/" "$dunstrc"

# Reload Dunst to apply the changes
pkill dunst && dunst &

echo "Dunst colors updated from pywal colors!"
