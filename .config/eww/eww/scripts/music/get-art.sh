#!/usr/bin/env bash

art_path="$HOME/.config/eww/scripts/music/eww-music-art.jpg"
meta_art=$(playerctl metadata mpris:artUrl 2>/dev/null)

if [[ -n "$meta_art" ]]; then
    clean_url="${meta_art#file://}"

    if [[ "$meta_art" == http* ]]; then
        wget -q "$meta_art" -O "$art_path"
    elif [[ -f "$clean_url" ]]; then
        cp "$clean_url" "$art_path"
    fi
else
    cp "$HOME/.config/eww/scripts/music/default_music.jpg" "$art_path" 2>/dev/null
fi
