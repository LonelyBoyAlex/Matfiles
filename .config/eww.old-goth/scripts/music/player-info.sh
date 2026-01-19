#!/usr/bin/env bash

title=$(playerctl metadata title 2>/dev/null)
artist=$(playerctl metadata artist 2>/dev/null)
status=$(playerctl status 2>/dev/null)

# position in seconds
pos=$(playerctl position 2>/dev/null)
pos=${pos%.*}

# raw length in microseconds
len_micro=$(playerctl metadata mpris:length 2>/dev/null)

# convert µs → s
if [[ "$len_micro" =~ ^[0-9]+$ ]]; then
    len=$((len_micro / 1000000))
else
    len=0
fi

# safety fallback (Spotify bug)
if (( len < pos )); then
    len=$((pos + 1))
fi

echo "{\"title\":\"${title:-No Media}\",\"artist\":\"${artist:-Unknown}\",\"status\":\"${status:-Stopped}\",\"position\":${pos:-0},\"length\":${len:-0}}"