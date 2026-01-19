#!/bin/bash

# Paths
WALL="$(cat ~/.cache/wal/wal)"
MODE="$(cat ~/.cache/mode)"  # 'light' or 'dark'

# Temp corrected wallpaper (gamma tweak)
#TMP_WALL="/tmp/wal_corrected.png"

# Pre-process wallpaper with gamma correction (helps extraction accuracy)
#convert "$WALL" -gamma 0.9 "$TMP_WALL"

# Available styles
styles=("default" "pastel" "rich" "vivid" "storm" "washed")

# Rofi prompt for style
STYLE=$(printf "%s\n" "${styles[@]}" | rofi -config ~/HyprlandScripts/thewe.rasi -dmenu -p "Select color variant:")
[ -z "$STYLE" ] && exit

# Detect average luminance (for adaptive tuning)
#AVG_LUM=$(convert "$WALL" -resize 1x1 txt:- | awk -F'[(),]' 'NR==2{print $2*0.2126 + $3*0.7152 + $4*0.0722}')

# Default params
SAT=""
CON=""
BACKEND="wal"

case "$STYLE" in
    pastel)
        SAT=0.25; CON=1.5; BACKEND="haishoku"
        ;;
    rich)
        SAT=0.6; CON=2.5; BACKEND="haishoku"
        ;;
    vivid)
        SAT=1.0; CON=3.0; BACKEND="fast_colorthief"
        ;;
    storm)
        SAT=0.5; CON=3.5; BACKEND="modern_colorthief"
        ;;
    washed)
        SAT=0.1; CON=4.5; BACKEND="modern_colorthief"
        ;;
#    accurate)
#        BACKEND="colorz"
#        if (( $(echo "$AVG_LUM > 150" | bc -l) )); then
#            SAT=0.6; CON=2.0
#        else
#            SAT=0.8; CON=2.5
#        fi
#       ;;
    *)
        BACKEND="wal"
        ;;
esac

# Construct wal command
WAL_CMD=(wal -i "$TMP_WALL" -n --backend "$BACKEND" --cols16)
[[ "$MODE" == "Light" ]] && WAL_CMD+=("-l")
[[ -n "$SAT" ]] && WAL_CMD+=("--saturate" "$SAT")
[[ -n "$CON" ]] && WAL_CMD+=("--contrast" "$CON")

# Apply theme
"${WAL_CMD[@]}"

# Clean up temp
#rm -f "$TMP_WALL"

# Reload waybar quietly
pkill waybar && waybar > /dev/null 2>&1 &
swaync-client --reload-css
