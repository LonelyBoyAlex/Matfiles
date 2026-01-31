#!/usr/bin/env bash

case "$1" in
    playpause) playerctl play-pause ;;
    next) playerctl next ;;
    prev) playerctl previous ;;
    *) echo "Unknown action" ;;
esac
