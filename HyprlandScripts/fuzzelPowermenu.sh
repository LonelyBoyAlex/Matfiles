#!/usr/bin/env bash

options="  Lock
  Poweroff
  Reboot
  Suspend
  Logout
  Cancel"

# Build fuzzel command as an array
fuzzel_cmd=(
  fuzzel
  --dmenu
  --auto-select
  --prompt "Power Menu:"
  --config "$HOME/.config/fuzzel/fuzzelniri.ini"
  -w 20
)

# Compositor-specific tweak
[[ "$DESKTOP_SESSION" == "niri" ]] && fuzzel_cmd+=(--anchor top)

# Run menu
choice=$(printf "%s\n" "$options" | "${fuzzel_cmd[@]}")

case "$choice" in
*Lock)
  case "$XDG_CURRENT_DESKTOP" in
  Niri | mango)
    pidof hyprlock >/dev/null || hyprlock
    ;;
  esac
  ;;

*Poweroff)
  systemctl poweroff
  ;;

*Reboot)
  systemctl reboot
  ;;

*Suspend)
  systemctl suspend
  ;;

*Logout)
  case "$XDG_CURRENT_DESKTOP" in
  Hyprland)
    hyprctl dispatch exit
    ;;
  Niri)
    niri msg action quit
    ;;
  mango)
    mmsg -q
    ;;
  *)
    loginctl terminate-session "$XDG_SESSION_ID"
    ;;
  esac
  ;;

*)
  exit 0
  ;;
esac
