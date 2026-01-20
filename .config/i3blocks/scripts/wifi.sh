#!/bin/bash

# Click to open network manager (optional)
[[ -n "$BLOCK_BUTTON" ]] && nm-connection-editor &

# Get SSID
SSID=$(iwgetid -r)

if [ -z "$SSID" ]; then
    echo "DISCONNECTED"
    echo "DISCONNECTED"
    echo "#FF0000" # Red color if down
else
    echo "$SSID"
    echo "$SSID"
    echo "#d3869b" # Your purple color
fi

