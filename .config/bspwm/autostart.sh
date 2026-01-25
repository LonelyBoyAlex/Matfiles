#!/bin/bash

# Autostart apps
picom -b --config ~/.config/picom/picomOpaq.conf &
feh --bg-fill $(cat ~/X11Scripts/currWall) &
polybar -c ~/.config/bspwm/polybar.ini &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
nm-applet &
blueman-applet &
udiskie --tray &
