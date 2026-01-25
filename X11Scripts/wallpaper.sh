#!/bin/env bash

case $1 in
"switcher")
  echo "switching wallpapers"
  ~/X11Scripts/rofiwall.sh
  ;;
"random")
  # Random wallpaper from X11Scripts/wallpapers/
  wallpapers_dir="$HOME/X11Scripts/wallpapers"
  if [ -d "$wallpapers_dir" ] && [ "$(ls -A "$wallpapers_dir"/*.jpg "$wallpapers_dir"/*.png 2>/dev/null | wc -l)" -gt 0 ]; then
    random_wall=$(ls "$wallpapers_dir"/*.jpg "$wallpapers_dir"/*.png 2>/dev/null | shuf -n 1)
    echo "$random_wall" >~/X11Scripts/currWall
    feh "$random_wall" --bg-fill
    #wal -i "$random_wall"
    notify-send "Random wallpaper applied!"
    #betterlockscreen -u $(cat X11Scripts/currWall) --fx blur &
  else
    notify-send "No wallpapers found in $wallpapers_dir"
    exit 1
  fi
  ;;
*)
  # Default: load current wallpaper
  feh $(cat ~/X11Scripts/currWall) --bg-fill
  #wal -i $(cat ~/X11Scripts/currWall)
  ;;
esac

polybar-msg cmd restart
~/X11Scripts/xterm-theme.sh
