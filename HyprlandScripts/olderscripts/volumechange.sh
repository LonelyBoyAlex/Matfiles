#!/bin/bash

# Configuration
NOTIFY_CMD="notify-send"  # Command for notifications
AUDIO_TOOL="wpctl"        # Audio management tool
STEP=5                    # Volume change step in percentage
LAST_VOLUME=100           # Default to 100% (for unmuting)

# Get the current volume as a percentage
get_volume() {
    volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}')
    echo "${volume%.*}"  # Return integer part of the volume
}

# Set the volume (accepts percentage values)
set_volume() {
    local volume=$1
    wpctl set-volume @DEFAULT_AUDIO_SINK@ "$volume%"
}

# Ensure the volume stays between 0% and 100%
clamp_volume() {
    local volume=$1
    if (( volume > 100 )); then
        echo 100
    elif (( volume < 0 )); then
        echo 0
    else
        echo "$volume"
    fi
}

# Handle volume change (increase or decrease)
adjust_volume() {
    local volume_change=$1
    local current_volume=$(get_volume)  # Get current volume
    local new_volume=$((current_volume + volume_change))  # Calculate new volume
    new_volume=$(clamp_volume "$new_volume")  # Clamp volume to be between 0% and 100%
    set_volume "$new_volume"  # Set the new volume
}

# Mute the volume and store the last known volume
mute_volume() {
    LAST_VOLUME=$(get_volume)  # Store the current volume
    set_volume 0  # Mute the volume
    $NOTIFY_CMD "Volume Muted" "Volume is now 0%"
}

# Unmute and restore the volume to the previous level
unmute_volume() {
    set_volume "$LAST_VOLUME"  # Restore the volume to the previous level
    $NOTIFY_CMD "Volume Unmuted" "Volume is restored to $LAST_VOLUME%"
}

# Check if the volume is currently muted and toggle mute/unmute
toggle_mute() {
    local current_volume=$(get_volume)

    if (( current_volume == 0 )); then
        unmute_volume  # If muted, restore the previous volume
    else
        mute_volume    # If not muted, mute the volume and save the current level
    fi
}

# Show current volume as a notification
show_notification() {
    local volume=$(get_volume)
    $NOTIFY_CMD "Current Volume" "${volume}%"
}

# Main script functionality
case "$1" in
    up)
        adjust_volume "$STEP"   # Increase volume by 5%
        show_notification
        ;;
    down)
        adjust_volume "-$STEP"   # Decrease volume by 5%
        show_notification
        ;;
    toggle)
        toggle_mute  # Toggle mute/unmute
        ;;
    *)
        show_notification     # Show current volume
        ;;
esac
