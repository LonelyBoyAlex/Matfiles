#!/usr/bin/env bash

options="  Lock
  Poweroff
  Reboot
  Suspend
  Logout
  Cancel"

choice=$(printf "%s\n" "$options" | \
    fuzzel --dmenu --auto-select --prompt "Power Menu: " \
    --config ~/.config/fuzzel/fuzzelniri.ini -w 20)

case "$choice" in
    *Lock)
        if [[ $XDG_CURRENT_DESKTOP == "Niri" ]]; then
            ~/.config/swaylock/swaylock-wal.sh
        elif [[ $XDG_CURRENT_DESKTOP == "mango" ]]; then
            pidof hyprlock >/dev/null || hyprlock
        fi
        ;;
    *Poweroff) systemctl poweroff ;;
    *Reboot) systemctl reboot ;;
    *Suspend) systemctl suspend ;;
    *Logout)
        if [[ $XDG_CURRENT_DESKTOP == "Hyprland" ]]; then
            hyprctl dispatch exit
        elif [[ $XDG_CURRENT_DESKTOP == "Niri" ]]; then
            niri msg action quit
        elif [[ $XDG_CURRENT_DESKTOP == "mango" ]]; then
            mmsg -q
        else
            loginctl terminate-session "$XDG_SESSION_ID"
        fi
        ;;
    *) exit 0 ;;
esac

