#!/usr/bin/env bash

MODE_FILE="${HOME}/.cache/mode"
WALL_ICON="󰏘"   # Nerd Font paint palette glyph

get_mode() {
  if [[ -f "$MODE_FILE" ]]; then
    tr -d '\r\n' < "$MODE_FILE"
  else
    echo "Dark"
  fi
}

list_themes() {
  local mode="$1"
  local out
  out=$(wal --theme 2>&1 | sed -r 's/\x1B\[[0-9;]*[mK]//g')

  awk -v mode="$mode" '
    BEGIN { show=0 }
    /^[[:space:]]*Dark Themes:/  { show=(mode=="Dark");  next }
    /^[[:space:]]*Light Themes:/ { show=(mode=="Light"); next }
    /^[[:space:]]*Extra:/        { show=0 }
    show && /^[[:space:]]*-/ {
      sub(/^[[:space:]]*-[[:space:]]*/,"")
      sub(/[[:space:]]*\(last used\)[[:space:]]*$/,"")
      print
    }
  ' <<< "$out"
}

apply_theme() {
  local theme="$1"
  [[ -z "$theme" ]] && return 1

  if wal --theme "$theme"; then
    notify-send "Theme Applied" "$theme"
  else
    notify-send "Theme Error" "Failed to apply: $theme"
  fi
}

apply_wallpaper() {
  local wallpaper_file="$HOME/.cache/wal/wal"
  if [[ -f "$wallpaper_file" ]]; then
    if wal -i "$(cat "$wallpaper_file")" -n; then
      notify-send "Theme Applied" "Wallpaper colors"
    else
      notify-send "Theme Error" "Failed to apply wallpaper theme"
    fi
  else
    notify-send "Theme Error" "No cached wallpaper found"
  fi
}

choose_theme() {
  local mode="$1"
  local themes chosen
  themes=$(list_themes "$mode")

  if [[ -z "$themes" ]]; then
    notify-send "Theme Picker" "No ${mode} themes found (check wal output)" 2>/dev/null || true
    echo "No ${mode} themes found. Check: wal --theme"
    return 1
  fi

  # Add Wallpaper option with nerd glyph
  chosen=$(printf "%s Wallpaper\n%s\n" "$WALL_ICON" "$themes" | rofi -dmenu -i -p "Select ${mode} theme:")

  case "$chosen" in
    "$WALL_ICON Wallpaper") apply_wallpaper ;;
    *) [[ -n "$chosen" ]] && apply_theme "$chosen" ;;
  esac
}

main() {
  local arg="${1-}"
  if [[ -n "$arg" ]]; then
    apply_theme "$arg" || {
      echo "Failed to apply theme: $arg"
      exit 1
    }
  else
    local mode
    mode=$(get_mode)
    [[ "$mode" != "Dark" && "$mode" != "Light" ]] && mode="Dark"
    choose_theme "$mode"
  fi
}

main "$@"
