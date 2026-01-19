#!/usr/bin/env bash
# niri msg -j workspaces | jq '[.[] | {id: .idx}] | length'

# Returns the total number of workspaces for Hyprland, Niri, or MangoWC

if [[ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]]; then
    hyprctl -j workspaces | jq '[.[] | {id: .id}] | length'

elif [[ "$XDG_CURRENT_DESKTOP" == "Niri" ]]; then
    niri msg -j workspaces | jq '[.[] | {id: .idx}] | length'

elif [[ "$XDG_CURRENT_DESKTOP" == "mango" ]]; then
    COUNT=$(mmsg -g -t | awk '/tag/ {count++} END {print count}')
    echo "${COUNT:-1}"

else
    echo 0
fi
