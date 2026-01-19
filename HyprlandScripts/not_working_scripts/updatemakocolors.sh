#!/bin/bash

# Path to your Mako config and the colors file
MAKO_CONFIG="$HOME/.config/mako/config"
WAL_COLORS="$HOME/.cache/wal/colors"

# Read colors from the .cache/wal/colors file
readarray -t COLORS < "$WAL_COLORS"

# Check if we have at least 5 colors defined
if [ "${#COLORS[@]}" -lt 5 ]; then
    echo "Not enough colors defined in $WAL_COLORS"
    exit 1
fi

# Modify Mako config with new colors
sed -i.bak \
    -e "s/^background-color=.*/background-color=${COLORS[0]}/" \
    -e "s/^border-color=.*/border-color=${COLORS[1]}/" \
    -e "/\[urgency=low\]/,/^\[/ s/^border-color=.*/border-color=${COLORS[2]}/" \
    -e "/\[urgency=normal\]/,/^\[/ s/^border-color=.*/border-color=${COLORS[3]}/" \
    -e "/\[urgency=high\]/,/^\[/ s/^border-color=.*/border-color=${COLORS[4]}/" \
    "$MAKO_CONFIG"

makoctl reload
echo "Mako config updated successfully."
