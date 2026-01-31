#/usr/bin/env bash
# detect current session
        if [[ $XDG_CURRENT_DESKTOP == "Hyprland" ]]; then
            hyprctl dispatch exit
        elif [[ $XDG_CURRENT_DESKTOP == "niri" ]]; then
            niri msg action quit
        elif [[ $XDG_CURRENT_DESKTOP == "mango" ]]; then
            mmsg -q
        else
            loginctl terminate-session "$XDG_SESSION_ID"
        fi
