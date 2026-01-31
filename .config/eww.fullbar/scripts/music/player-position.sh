#!/usr/bin/env bash

# strip decimal part safely
pos=$(playerctl position 2>/dev/null || echo 0)
pos=${pos%.*}

# format mm:ss
printf "%d:%02d\n" $((pos / 60)) $((pos % 60))
