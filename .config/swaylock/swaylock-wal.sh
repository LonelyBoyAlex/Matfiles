#!/bin/bash
# swaylock with pywal16 colors + wallpaper background

# Load pywal16 colors
if [ -f "${HOME}/.cache/wal/colors.sh" ]; then
    . "${HOME}/.cache/wal/colors.sh"
else
    echo "Pywal colors not found, exiting."
    exit 1
fi

# Grab the current wallpaper (set by pywal)
WALLPAPER="$(cat ${HOME}/.cache/wal/wal)"
if [ ! -f "$WALLPAPER" ]; then
    echo "Wallpaper not found, exiting."
    exit 1
fi

exec swaylock \
    --image="$WALLPAPER" \
    --scaling=fill \
    \
    --inside-color=$color0 \
    --inside-clear-color=$color4 \
    --inside-ver-color=$color2 \
    --inside-wrong-color=$color1 \
    \
    --ring-color=$color8 \
    --ring-clear-color=$color4 \
    --ring-ver-color=$color2 \
    --ring-wrong-color=$color1 \
    \
    --key-hl-color=$color7 \
    --bs-hl-color=$color3 \
    \
    --separator-color=00000000 \
    \
    --text-color=$color15 \
    --text-clear-color=$color15 \
    --text-ver-color=$color15 \
    --text-wrong-color=$color15 \
    \
    --indicator-caps-lock \
    --indicator-radius=200 \
    --indicator-thickness=10 \
    \
    --show-failed-attempts \
    --show-keyboard-layout \
    --daemonize \
    --timestr "%H:%M" \
    --datestr "%a %-d/%-m" \
    --fade-in 1 \
    --effect-vignette 20:1.5\
    \
    --effect-blur 10x10 \
    --effect-scale 0.5 \
    --clock \
    --indicator
