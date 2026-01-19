#!/bin/bash

# If idle for 15s, power down the output
swayidle -w \
		timeout 15 'swaymsg "output * dpms off"' \
		resume 'swaymsg "output * dpms on"' &


# Lock screen immediately
swaylock --image ~/.cache/currwall


# Kill the last instance of swayidle so the timer doesn't keep running in background
pkill --newest swayidle
