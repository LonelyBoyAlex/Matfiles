#!/bin/bash

# --- Config ---
FUZZEL_CONFIG="$HOME/.config/fuzzel/fuzzelniri.ini"
OUTPUT_DIR="$HOME/Pictures/hyprshot"
CACHE_JSON="$HOME/.cache/wal/colors.json" # pywal JSON export

# Ensure jq exists
if ! command -v jq &>/dev/null; then
    notify-send "❌ Missing jq" "Install jq to parse colors.json"
    exit 1
fi

# Load pywal colors from JSON
if [[ -f "$CACHE_JSON" ]]; then
    FG=$(jq -r '.special.foreground' "$CACHE_JSON")
    BG=$(jq -r '.special.background' "$CACHE_JSON")
else
    notify-send "❌ No pywal JSON found" "Run wal first to generate colors"
    exit 1
fi

# Ensure hyprshot installed
if ! command -v hyprshot &>/dev/null; then
    notify-send "❌ Screenshot tool not found" "Install hyprshot to continue."
    exit 1
fi

# --- Menu (emoji give a nice visual hint) ---
CHOICE=$(printf "    Fullscreen\n    Region\n    Clipboard\n    Window\n" |
    fuzzel --config "$FUZZEL_CONFIG" --dmenu -p "Screenshot:  " --placeholder "   ")

# Actions
case "$CHOICE" in
*Fullscreen*)
    hyprshot -m output -o "$OUTPUT_DIR"
    ;;
*Region*)
    hyprshot -m region -o "$OUTPUT_DIR"
    ;;
*Clipboard*)
    hyprshot -m region --clipboard-only
    ;;
*Window*)
    hyprshot -m window -o "$OUTPUT_DIR"
    ;;
*)
    exit 0
    ;;
esac

