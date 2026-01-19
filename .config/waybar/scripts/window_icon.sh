#!/usr/bin/env bash

empty_icon=""

# Explicit app mapping
declare -A icons=(
    ["firefox"]=""
    ["zen"]=""
    ["brave-browser"]="󰖟"
    ["alacritty"]=""
    ["kitty"]=""
    ["code-oss"]="󰨞"
    ["nvim"]=""
    ["thunar"]=""
    ["discord"]="󰙯"
)

# Category → glyph mapping
declare -A category_icons=(
    ["Network"]="󰖟"      # Browsers
    ["AudioVideo"]="󰐺"   # Media players
    ["Development"]="󰨞"  # IDEs, editors
    ["Utility"]="󰂺"      # Generic tools
    ["Office"]="󰧮"       # Office apps
    ["Graphics"]="󰋩"     # GIMP, Inkscape etc
    ["Game"]="󰊴"         # Games
)

focused_app=$(hyprctl activewindow -j | jq -r '.class' 2>/dev/null)

if [[ -z "$focused_app" || "$focused_app" == "null" ]]; then
    echo "$empty_icon"
    exit 0
fi

focused_app=$(echo "$focused_app" | tr '[:upper:]' '[:lower:]')

# 1. Direct mapping
if [[ -n "${icons[$focused_app]}" ]]; then
    echo "${icons[$focused_app]}"
    exit 0
fi

# 2. Try to detect category via .desktop file
desktop_file=$(grep -il "StartupWMClass=$focused_app" /usr/share/applications/*.desktop ~/.local/share/applications/*.desktop 2>/dev/null | head -n 1)

if [[ -n "$desktop_file" ]]; then
    category=$(grep -m1 "^Categories=" "$desktop_file" | cut -d= -f2 | cut -d';' -f1)
    if [[ -n "${category_icons[$category]}" ]]; then
        echo "${category_icons[$category]}"
        exit 0
    fi
fi

# 3. Fallback
echo "$empty_icon"
