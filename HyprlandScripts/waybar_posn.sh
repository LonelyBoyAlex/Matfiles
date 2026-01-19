#!/bin/bash

#CONFIG_FILE=$HOME/.config/waybar/config.jsonc
#CONFIG_FILE2=$HOME/testconfigs/config.jsonc

# Get current position
#CURRENT_POS=$(grep -oP '"position":\s*"\K(top|bottom)' "$CONFIG_FILE")

# Toggle between top and bottom
#if [[ "$CURRENT_POS" == "top" ]]; then
#    NEW_POS="bottom"
#else
#    NEW_POS="top"
#fi

# Modify the config file
#sed -i -E "s/(\"position\":[[:space:]]*\")([a-zA-Z]+)(\")/\1$NEW_POS\3/" "$CONFIG_FILE"


# Get current position
#CURRENT_POS2=$(grep -oP '"position":\s*"\K(top|bottom)' "$CONFIG_FILE2")

# Toggle between top and bottom
#if [[ "$CURRENT_POS2" == "top" ]]; then
#    NEW_POS2="bottom"
#else
#    NEW_POS2="top"
#fi

# Modify the config file
#sed -i -E "s/(\"position\":[[:space:]]*\")([a-zA-Z]+)(\")/\1$NEW_POS2\3/" "$CONFIG_FILE2"

# Restart Waybar to apply changes
#pkill -SIGUSR2 waybar


#!/bin/bash

CONFIG_FILE=$HOME/.config/waybar/config.jsonc

# Get current position
CURRENT_POS=$(grep -oP '"position":\s*"\K(top|bottom|left|right)' "$CONFIG_FILE")

# Toggle position
case "$CURRENT_POS" in
    top)
        NEW_POS="bottom"
        ;;
    bottom)
        NEW_POS="top"
        ;;
    left)
        NEW_POS="right"
        ;;
    right)
        NEW_POS="left"
        ;;
    *)
        echo "Unknown or missing position in config. Defaulting to top."
        NEW_POS="top"
        ;;
esac

# Modify the config file
sed -i -E "s/(\"position\"[[:space:]]*:[[:space:]]*\")[a-zA-Z]+(\"?)/\1$NEW_POS\2/" "$CONFIG_FILE"

# Restart Waybar to apply changes
if pgrep -x "waybar" > /dev/null; then
    pkill -SIGUSR2 waybar
    echo "Waybar position changed to '$NEW_POS'."
else
    echo "Waybar is not running."
fi

