#!/usr/bin/env bash

CACHEFILE="$HOME/.cache/eww-apps.json"

[ -f "$CACHEFILE" ] && cat "$CACHEFILE" || echo "[]"

