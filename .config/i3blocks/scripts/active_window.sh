#!/bin/sh

# Function to get the class name of the currently focused window
get_class() {
    # Get the ID of the active window
    id=$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $5}')
    
    # If no window is focused (id is 0x0), print nothing
    if [ "$id" = "0x0" ]; then
        echo ""
        return
    fi

    # Get the WM_CLASS property (usually "AppName", "ClassName")
    # We pick the second string which is usually the capitalized App Name
    xprop -id "$id" WM_CLASS 2>/dev/null | awk -F '"' '{print $4}'
}

# Run once at startup
get_class

# Spy on the root window for focus changes
xprop -root -spy _NET_ACTIVE_WINDOW | while read -r _; do
    get_class
done

