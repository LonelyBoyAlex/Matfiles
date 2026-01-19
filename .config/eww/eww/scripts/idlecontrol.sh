#!/usr/bin/env bash

# Where to start each daemon from
SWAYIDLE_CMD="$HOME/.config/niri/scripts/swayidle.sh"
HYPRIDLE_CMD="hypridle"

ICON_ENABLED="󰒲"   # idle daemon running
ICON_DISABLED="󰒳" # not running

get_active_daemon() {
    if pgrep -x hypridle >/dev/null; then
        echo "hypridle"
    elif pgrep -x swayidle >/dev/null; then
        echo "swayidle"
    else
        echo ""
    fi
}

get_status() {
    if [ -n "$(get_active_daemon)" ]; then
        echo "$ICON_ENABLED"
    else
        echo "$ICON_DISABLED"
    fi
}

is_niri_desktop() {
    # Check XDG_CURRENT_DESKTOP, may be exactly "niri" or contain it in a list.[web:67][web:71][web:77]
    case "$XDG_CURRENT_DESKTOP" in
        *niri*|*Niri*|*NIRI*)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

case "$1" in
    toggle)
        active="$(get_active_daemon)"

        if [ -n "$active" ]; then
            # Something is running: kill both to be safe
            killall hypridle swayidle 2>/dev/null
            echo "$ICON_DISABLED"
        else
            # Nothing running: choose based on XDG_CURRENT_DESKTOP
            if is_niri_desktop; then
                # On niri: use swayidle wrapper
                bash -c "$SWAYIDLE_CMD &"
            else
                # Anything else: use hypridle
                bash -c "$HYPRIDLE_CMD &"
            fi
            echo "$ICON_ENABLED"
        fi
        ;;
    status|"")
        get_status
        ;;
esac