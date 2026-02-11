#!/usr/bin/env bash

mode="$1"

playerctl --follow metadata --format '{{status}}|{{title}}|{{artist}}|{{album}}' 2>/dev/null |
  while IFS="|" read -r status title artist album; do
    # Default: stopped
    class="stopped"
    text="󰎇 Nothing Playing 󰎇"

    if [ -n "$status" ] && [ "$status" != "Stopped" ]; then
      case "$status" in
      Playing)
        class="playing"
        icon="" # pause icon
        ;;
      Paused)
        class="paused"
        icon="" # play icon
        ;;
      *)
        class="stopped"
        icon="󰽶"
        ;;
      esac

      full_text="$icon $title : $artist / $album"

      max=30
      if [ ${#full_text} -gt $max ]; then
        text="${full_text:0:$((max - 1))}…"
      else
        text="$full_text"
      fi
    fi

    if [ "$mode" = "class" ]; then
      echo "$class"
    else
      echo "$text"
    fi
  done
