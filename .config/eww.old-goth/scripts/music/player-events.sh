#!/usr/bin/env bash

eww="eww -c $HOME/.config/eww"

playerctl --follow metadata | while read -r _; do
    info="$($HOME/.config/eww/scripts/music/player-info.sh)"

    $eww update music_title="$(echo "$info" | jq -r '.title')"
    $eww update music_artist="$(echo "$info" | jq -r '.artist')"
    $eww update music_status="$(echo "$info" | jq -r '.status')"
    $eww update music_position="$(echo "$info" | jq -r '.position')"
    $eww update music_length="$(echo "$info" | jq -r '.length')"

    # Update album art
    $HOME/.config/eww/scripts/music/get-art.sh
done