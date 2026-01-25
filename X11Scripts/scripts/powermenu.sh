#!/bin/bash

ROFI_FONT="JetBrains Mono Nerd Font Propo 20"

LOCK="    "
LOGOUT="    "
SUSPEND="  󰒲  "
REBOOT="    "
SHUTDOWN="    "

# Detect WM / DE and set logout command
case "$XDG_SESSION_DESKTOP" in
qtile*)
  LOGOUTCMD="qtile cmd-obj -o cmd -f 'shutdown'"
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
  echo -e "    Yes\n    No" | rofi -i -dmenu \
    -p "Are you sure?" \
    -config ~/X11Scripts/rofi/rofi-power.rasi \
    -font "$ROFI_FONT" \
    -theme-str 'window {width: 400px; height: 300px;}'
}

lock() {
  #  i3lock-fancy
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
  -config ~/X11Scripts/rofi/rofi-power.rasi \
  -font "$ROFI_FONT" \
  -theme-str 'window {width: 450px; height:400px;}')

[[ -z "$chosen" ]] && exit 0

answer=$(confirm)

if [[ "$answer" == "    Yes" ]]; then
  case "$chosen" in
  *Lock) lock ;;
  *Logout) logout ;;
  *Suspend) suspend ;;
  *Reboot) reboot ;;
  *Shutdown) shutdown ;;
  esac
fi
