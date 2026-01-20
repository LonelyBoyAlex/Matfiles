#!/bin/bash

# Configuration
NOTIFY_CMD="notify-send"
BRIGHTNESS_TOOL="brightnessctl"
STEP=5   # Brightness change step in percentage
NOTIFY_ID=9998  # Unique ID for brightness notifications

# Get current brightness percentage
get_brightness() {
    brightness=$($BRIGHTNESS_TOOL get)
    max_brightness=$($BRIGHTNESS_TOOL max)
    echo $((brightness * 100 / max_brightness))  # Convert to percentage
}

# Set brightness (accepts percentage)
set_brightness() {
    local new_brightness=$1
    $BRIGHTNESS_TOOL set "${new_brightness}%"
}

# Ensure brightness stays between 1% and 100% (avoid complete black screen)
clamp_brightness() {
    local brightness=$1
    if (( brightness > 100 )); then
        echo 100
    elif (( brightness < 1 )); then
        echo 1
    else
        echo "$brightness"
    fi
}

# Adjust brightness up/down
adjust_brightness() {
    local change=$1
    local current_brightness=$(get_brightness)
    local new_brightness=$((current_brightness + change))
    new_brightness=$(clamp_brightness "$new_brightness")
    set_brightness "$new_brightness"
}

# Show progressive brightness notification
show_notification() {
    local brightness=$(get_brightness)
    $NOTIFY_CMD -r $NOTIFY_ID -h int:value:$brightness -h string:synchronous:brightness "Brightness: $brightness%"
}

# Main functionality
case "$1" in
    up)
        adjust_brightness "$STEP"
        show_notification
        ;;
    down)
        adjust_brightness "-$STEP"
        show_notification
        ;;
    *)
        show_notification
        ;;
esac

