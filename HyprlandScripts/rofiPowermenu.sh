#!/bin/bash

ROFI_FONT="JetBrains Mono Nerd Font 16"

LOCK=""
LOGOUT=""
SUSPEND="󰒲"
REBOOT=""
SHUTDOWN=""

# Detect WM / DE and set logout command
case "$XDG_SESSION_DESKTOP" in
*[Qq]tile*)
  LOGOUTCMD="qtile cmd-obj -o cmd -f shutdown"
  ;;
i3)
  LOGOUTCMD="i3-msg exit"
  ;;
*)
  # Safe fallback
  LOGOUTCMD="loginctl terminate-user $USER"
  ;;
esac

options="$SHUTDOWN  Shutdown
$LOCK  Lock
$LOGOUT  Logout
$SUSPEND  Suspend
$REBOOT  Reboot"

confirm() {
  echo -e "Yes\nNo" | rofi -i -dmenu \
    -p "Are you sure?" \
    -config ~/HyprlandScripts/rofistyles/i3apps.rasi \
    -font "$ROFI_FONT" \
    -theme-str 'window {width: 400px; height: 180px;}'
}
#    -config ~/X11Scripts/rofi/pmenu.rasi \

lock() {
  # i3lock-fancy
  betterlockscreen -l blur
}

logout() {
  eval "$LOGOUTCMD"
}

suspend() {
  systemctl suspend
}

reboot() {
  systemctl reboot
}

shutdown() {
  systemctl poweroff
}

chosen=$(echo -e "$options" | rofi -i -dmenu \
  -p "Power" \
  -config ~/HyprlandScripts/rofistyles/i3apps.rasi \
  -font "$ROFI_FONT" \
  -theme-str 'window {width: 450px; height:300px;}')

[[ -z "$chosen" ]] && exit 0

answer=$(confirm)

if [[ "$answer" == "Yes" ]]; then
  case "$chosen" in
  *Lock) lock ;;
  *Logout) logout ;;
  *Suspend) suspend ;;
  *Reboot) reboot ;;
  *Shutdown) shutdown ;;
  esac
fi
