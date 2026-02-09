#!/usr/bin/env bash
# pkill rofi || rofi -show drun -theme ~/HyprlandScripts/style-12.rasi
pidof fuzzel >/dev/null && killall fuzzel || fuzzel --config ~/.config/fuzzel/fuzzelniri.ini
