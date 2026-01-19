#!/bin/bash

# Configuration
NOTIFY_CMD="notify-send"
BRIGHTNESS_TOOL="brightnessctl"
NOTIFY_ID=9998
FACTOR=1.15

# Use a fixed symbolic icon
ICON_NAME="display-brightness-symbolic"

# Get current brightness percentage
get_brightness() {
    brightness=$($BRIGHTNESS_TOOL get)
    max_brightness=$($BRIGHTNESS_TOOL max)
    echo $((brightness * 100 / max_brightness))
}

set_brightness() {
    local new_brightness=$1
    $BRIGHTNESS_TOOL set "${new_brightness}%"
}

clamp_brightness() {
    local brightness=$1
    (( brightness > 100 )) && echo 100 && return
    (( brightness < 0 )) && echo 0 && return
    echo "$brightness"
}

adjust_brightness() {
    local change=$1
    local current_brightness=$(get_brightness)

    if (( current_brightness == 0 && change > 0 )); then
        new_brightness=1
    elif (( current_brightness <= 6 && change > 0 )); then
        new_brightness=$((current_brightness + 1))
    elif (( current_brightness > 6 && change > 0 )); then
        new_brightness=$(awk "BEGIN {print int($current_brightness * $FACTOR)}")
    elif (( current_brightness > 6 && change < 0 )); then
        new_brightness=$(awk "BEGIN {print int($current_brightness / $FACTOR)}")
    else
        new_brightness=$((current_brightness - 1))
    fi

    new_brightness=$(clamp_brightness "$new_brightness")
    set_brightness "$new_brightness"
}

show_notification() {
    local brightness=$(get_brightness)
    $NOTIFY_CMD -r $NOTIFY_ID -h int:value:$brightness \
        -h string:synchronous:brightness \
        -i "$ICON_NAME" "Brightness: $brightness%"
}

case "$1" in
    up)
        adjust_brightness 1
        show_notification
        ;;
    down)
        adjust_brightness -1
        show_notification
        ;;
    *)
        show_notification
        ;;
esac
