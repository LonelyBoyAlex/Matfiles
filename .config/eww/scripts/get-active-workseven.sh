#!/usr/bin/env bash
# Returns the currently active workspace for Hyprland, Niri, MangoWC, or i3
# Workspace count adapts based on active Eww theme

ACTIVE=1
WORKSPACES=5   # default

EWW_LINK="$HOME/.config/eww/eww.yuck"

# --- Detect theme and adjust workspace count ---
if [[ -L "$EWW_LINK" ]]; then
  THEME_PATH=$(readlink -f "$EWW_LINK")

  # Themes that should have 7 workspaces
  THEMES_7=("topgoth" "topbar" "largebar")

  for theme in "${THEMES_7[@]}"; do
    if [[ "$THEME_PATH" == *"/$theme/"* ]]; then
      WORKSPACES=7
      break
    fi
  done
fi

# --- WM-specific logic ---
if [[ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]]; then
  ACTIVE=$(hyprctl activeworkspace -j | jq -r '.id')

  # Map into 1..WORKSPACES range
  ACTIVE=$((((ACTIVE - 1) % WORKSPACES) + 1))

elif [[ "$XDG_CURRENT_DESKTOP" == "Niri" ]]; then
  ACTIVE=$(niri msg -j workspaces | jq -r '.[] | select(.is_active) | .idx')
  ACTIVE=$((((ACTIVE - 1) % WORKSPACES) + 1))

elif [[ "$XDG_CURRENT_DESKTOP" == "mango" ]]; then
  ACTIVE=$(mmsg -g -t | awk '/tag/ && $4==1 { print $3; exit }')
  ACTIVE=${ACTIVE:-1}
  ACTIVE=$((((ACTIVE - 1) % WORKSPACES) + 1))

elif [[ "$XDG_CURRENT_DESKTOP" == "i3" ]]; then
  ACTIVE=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused) | .num')
  ACTIVE=$((((ACTIVE - 1) % WORKSPACES) + 1))

else
  exit 0
fi

echo "$ACTIVE"
