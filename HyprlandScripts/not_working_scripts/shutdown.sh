#!/bin/bash

# Function to display a countdown notification
function countdown_notification {
    seconds=30
    while [ $seconds -gt 0 ]; do
        # Show the notification
        dunstify --replace=shutdown_notify \
            "Shutdown in $seconds seconds." \
            "Press Ctrl+C to cancel." \
            --icon="dialog-shutdown" \
            --timeout=1

        sleep 1
        seconds=$((seconds - 1))
    done

    # Power off the system
    systemctl poweroff
}

# Ask for confirmation to initiate the shutdown
dunstify --replace=shutdown_confirm \
    "Shutdown Confirmation" \
    "System will shut down in 30 seconds." \
    --icon="dialog-shutdown" \
    --action="poweroff:Power Off" \
    --action="cancel:Cancel" \
    --timeout=0

# Wait for user input
while true; do
    read -r action
    if [[ $action == "poweroff" ]]; then
        countdown_notification
        break
    elif [[ $action == "cancel" ]]; then
        exit 0
    fi
done
