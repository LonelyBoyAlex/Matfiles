#!/usr/bin/env bash

dir="$HOME/HyprlandScripts"
theme='style-10'

## Detect current Wayland compositor (Hyprland or Niri)
if [[ "$XDG_CURRENT_DESKTOP" =~ [Hh]yprland ]]; then
    WINDOWMAN="Hyprland"
elif [[ "$XDG_CURRENT_DESKTOP" =~ [Nn]iri ]]; then
    WINDOWMAN="Niri"
elif [[ "$XDG_CURRENT_DESKTOP" =~ [Mm]ango ]]; then
    WINDOWMAN="Hyprland"
else
    # Fallback check (just in case)
    if pgrep -x hyprland >/dev/null; then
        WINDOWMAN="Hyprland"
    elif pgrep -x niri >/dev/null; then
        WINDOWMAN="Niri"
    else
        WINDOWMAN="Unknown"
    fi
fi


if [[ $WINDOWMAN == "Hyprland" ]]; then
    ## Run
    rofi \
       -show drun \
       -theme ${dir}/${theme}.rasi
elif [[ $WINDOWMAN == "Niri" ]]; then
    pidof fuzzel >/dev/null && killall fuzzel || fuzzel --config ~/.config/fuzzel/fuzzelniri.ini
else
  rofi -show drun -theme $HOME/.cache/wal/colors-rofi-dark.rasi
fi

