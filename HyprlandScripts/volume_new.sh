#!/bin/bash

# Configuration
NOTIFY_CMD="notify-send"
AUDIO_TOOL="wpctl"
STEP=5
LAST_VOLUME=100
NOTIFY_ID=9999

ICON_LOW="audio-volume-low-symbolic"
ICON_MEDIUM="audio-volume-medium-symbolic"
ICON_HIGH="audio-volume-high-symbolic"
ICON_MUTED="audio-volume-muted-symbolic"

get_volume() {
    volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}')
    echo "${volume%.*}"
}

get_icon() {
    local volume=$1
    if (( volume == 0 )); then
        echo "$ICON_MUTED"
    elif (( volume < 35 )); then
        echo "$ICON_LOW"
    elif (( volume < 65 )); then
        echo "$ICON_MEDIUM"
    else
        echo "$ICON_HIGH"
    fi
}

set_volume() {
    local volume=$1
    wpctl set-volume @DEFAULT_AUDIO_SINK@ "$volume%"
}

clamp_volume() {
    local volume=$1
    (( volume > 100 )) && echo 100 && return
    (( volume < 0 )) && echo 0 && return
    echo "$volume"
}

adjust_volume() {
    local volume_change=$1
    local current_volume=$(get_volume)
    local new_volume=$((current_volume + volume_change))
    new_volume=$(clamp_volume "$new_volume")
    set_volume "$new_volume"
}

notify_persistent() {
    local volume=$1
    local icon=$2
    $NOTIFY_CMD -r $NOTIFY_ID -i "$icon" \
        -h int:value:$volume \
        -h string:synchronous:volume \
        -t 1500 \
        "Volume: $volume%" ""
}

mute_volume() {
    LAST_VOLUME=$(get_volume)
    set_volume 0
    notify_persistent 0 "$ICON_MUTED"
}

unmute_volume() {
    set_volume "$LAST_VOLUME"
    local icon=$(get_icon "$LAST_VOLUME")
    notify_persistent "$LAST_VOLUME" "$icon"
}

toggle_mute() {
    local current_volume=$(get_volume)
    if (( current_volume == 0 )); then
        unmute_volume
    else
        mute_volume
    fi
}

show_notification() {
    local volume=$(get_volume)
    local icon=$(get_icon "$volume")
    notify_persistent "$volume" "$icon"
}

case "$1" in
    up)
        adjust_volume "$STEP"
        show_notification
        ;;
    down)
        adjust_volume "-$STEP"
        show_notification
        ;;
    toggle)
        toggle_mute
        ;;
    *)
        show_notification
        ;;
esac
