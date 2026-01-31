#!/bin/bash
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent &
~/.config/niri/scripts/swaync.sh &
eww-daemon &
swww-daemon &
swww img $(readlink ~/.config/themes/active/wallpapers/current) &
~/HyprlandScripts/ewwStarter.sh goth &
swww-daemon -n wallpapes &
swww img -n wallpapes .cache/wallblurred.png &
~/.config/niri/scripts/swayidle.sh && notify-send 'swayidle' &
udiskie --tray &
nm-applet &
blueman-applet &
