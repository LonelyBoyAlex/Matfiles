#!/bin/bash
shopt -s nocasematch # Ignore case for all pattern matches

# --- Config ---
FUZZEL_CONFIG="$HOME/.config/fuzzel/fuzzelniri.ini"
ROFI_CONFIG="$HOME/HyprlandScripts/rofistyles/scrsht.rasi"
ICON_DIR="$HOME/.config/rofi/icons"
OUTPUT_DIR="$HOME/Pictures/hyprshot"
#CACHE_JSON="$HOME/.cache/wal/colors.json" # pywal JSON export
CACHE_JSON="$HOME/HyprlandScripts/rofistyles/colors.json" #matugen colors

# Ensure jq exists
if ! command -v jq &>/dev/null; then
  notify-send "❌ Missing jq" "Install jq to parse colors.json"
  exit 1
fi

# Load pywal colors from JSON
if [[ -f "$CACHE_JSON" ]]; then
  FG=$(jq -r '.colors.color15' "$CACHE_JSON")
  BG=$(jq -r '.colors.color0' "$CACHE_JSON")
  LIGHT_ACCENT=$(jq -r '.colors.color10' "$CACHE_JSON")
  DARK_ACCENT=$(jq -r '.colors.color10' "$CACHE_JSON")
else
  notify-send "❌ No pywal JSON found" "Run wal first to generate colors"
  exit 1
fi

# Convert hex → brightness (0–255)
hex_to_brightness() {
  local hex="$1"
  local r=$((16#${hex:1:2}))
  local g=$((16#${hex:3:2}))
  local b=$((16#${hex:5:2}))
  echo $(((r * 299 + g * 587 + b * 114) / 1000))
}

bg_brightness=$(hex_to_brightness "$BG")

# Pick icon color depending on wallpaper darkness
if ((bg_brightness < 128)); then
  ICON_COLOR="$LIGHT_ACCENT" # wallpaper is dark → use light icon
else
  ICON_COLOR="$DARK_ACCENT" # wallpaper is light → use darker icon
fi

# Ensure hyprshot installed
if ! command -v hyprshot &>/dev/null; then
  notify-send "❌ Screenshot tool not found" "Install hyprshot to continue."
  exit 1
fi

# Function: recolor SVG icons in place
recolor_icons() {
  mkdir -p "$ICON_DIR/recolored"
  for icon in "$ICON_DIR"/*.svg; do
    [[ -f "$icon" ]] || continue
    out="$ICON_DIR/recolored/$(basename "$icon")"

    # Replace existing fills or inject into the first <path> or <svg>
    if grep -q 'fill="#' "$icon"; then
      sed -E "s/fill=\"#[0-9A-Fa-f]{6}\"/fill=\"$ICON_COLOR\"/g" "$icon" >"$out"
    else
      # Inject fill before the closing ">" of the first <path> or <svg> tag
      sed -E "0,/<(path|svg)([^>]*)>/s//<\1\2 fill=\"$ICON_COLOR\">/" "$icon" >"$out"
    fi
  done
}

# Recolor before showing menu
recolor_icons

# Define menu with recolored icons
#CHOICE=$(printf "  Fullscreen\x00icon\x1f$ICON_DIR/recolored/fullscreen.svg\n  Region\x00icon\x1f$ICON_DIR/recolored/region.svg\n  Clipboard\x00icon\x1f$ICON_DIR/recolored/clipboard.svg\n  Window\x00icon\x1f$ICON_DIR/recolored/window.svg\n" |
#    rofi -dmenu -config "$ROFI_CONFIG" -p "Screenshot:" -show-icons)

case "$XDG_CURRENT_DESKTOP" in
"Hyprland")
  CHOICE=$(printf "  Fullscreen\x00icon\x1f$ICON_DIR/recolored/fullscreen.svg\n  Region\x00icon\x1f$ICON_DIR/recolored/region.svg\n  Clipboard\x00icon\x1f$ICON_DIR/recolored/clipboard.svg\n  Window\x00icon\x1f$ICON_DIR/recolored/window.svg\n" |
    rofi -dmenu -config "$ROFI_CONFIG" -p "Screenshot:" -show-icons)
  ;;
"niri" | "mangowc")
  CHOICE=$(printf "    Fullscreen\n    Region\n    Clipboard\n    Window\n" |
    fuzzel --config "$FUZZEL_CONFIG" --dmenu -p "Screenshot:  " --placeholder "   " --auto-select -w 20)
  ;;
*)
  echo "no cant do!! find some other script or extend it"
  ;;
esac

# Actions
case "$CHOICE" in
*Fullscreen*)
  hyprshot -m output -m eDP-1 -o "$OUTPUT_DIR"
  #notify-send "📸 Screenshot" "Fullscreen saved in $OUTPUT_DIR"
  ;;
*Region*)
  hyprshot -m region -o "$OUTPUT_DIR"
  # notify-send "📸 Screenshot" "Region saved in $OUTPUT_DIR"
  ;;
*Clipboard*)
  hyprshot -m region --clipboard-only
  # notify-send "📋 Screenshot" "Region copied to clipboard"
  ;;
*Window*)
  hyprshot -m window -o "$OUTPUT_DIR"
  # notify-send "📸 Screenshot" "Window saved in $OUTPUT_DIR"
  ;;
*)
  exit 0
  ;;
esac
