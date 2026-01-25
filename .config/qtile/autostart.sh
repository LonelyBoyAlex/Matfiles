#!/bin/bash
# swap esc and caps
#setxkbmap -option caps:swapescape &

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
picom &
dunst &
nm-applet &
blueman-applet &
udiskie --tray &
# feh --bg-fill .cache/currwall.png &
#("$HOME/.cache/currwall.png")])
$HOME/X11Scripts/wallpaper.sh
