#!/bin/bash
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
~/.config/niri/scripts/swaync.sh &
eww-daemon &
awww-daemon &
awww img $(readlink ~/.config/themes/active/wallpapers/current) &
#~/HyprlandScripts/ewwStarter.sh goth &
~/HyprlandScripts/ewwTheme.sh restore &
awww-daemon -n "wallpapes" &
awww img -n "wallpapes" .cache/wallblurred.png &
#~/.config/niri/scripts/swayidle.sh && notify-send 'swayidle' &
hypridle &
udiskie --tray &
nm-applet &
blueman-applet &
