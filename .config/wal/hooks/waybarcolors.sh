#!/bin/bash

ln -sf "$HOME/.cache/wal/colors-waybar.css" "$HOME/.config/waybar/colors.css"
ln -sf "$HOME/.config/waybar/colors-waybar.css" "$HOME/.config/wlogout/colors.css"

pkill waybar && nohup waybar >/dev/null 2>&1 &
