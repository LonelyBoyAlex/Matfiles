#!/bin/bash
#set +e

# export session vars for KDE services (kwallet, etc.)
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots

# start kwallet daemon (KDE6)
#kwalletd6 &

# notify
swaync &

# night light
# wlsunset -T 3501 -t 3500 &

# wallpaper (center-growing circular transition from ~/.cache/currwall)
swww-daemon &
swww img ~/.cache/currwall \
  --transition-type center \
  --transition-duration 4 &

# top bar
# waybar &
~/HyprlandScripts/ewwStarter.sh bar &

# keep clipboard content
# wl-clip-persist --clipboard regular --reconnect-tries 0 &

# clipboard content manager
# wl-paste --type text --watch cliphist store &

# xwayland dpi scale
echo "Xft.dpi: 125" | xrdb -merge
gsettings set org.gnome.desktop.interface text-scaling-factor 1.00
#gsettings set org.gnome.desktop.interface text-scaling-factor 1.25

# Permission authentication
#/usr/lib/xfce-polkit/xfce-polkit &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# idler
pidof hypridle >/dev/null 2>&1 || hypridle &

# tui tools
nm-applet &
blueman-applet &
