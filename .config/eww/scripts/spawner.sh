#!/usr/bin/env bash
# scripts/spawner.sh
# Usage: scripts/spawner.sh onclick powerrmenu

set -euo pipefail

action="${1:-}"
target="${2:-}"

case "$action" in
  onclick)
    case "$target" in
      powermenu)
            if eww active-windows | grep -qx "powermenu: powermenu";
            then eww update isrevealpower=false;
               sleep 0.30;
               eww close powermenu;
            else eww open powermenu; 
            eww update isrevealpower=true;
            fi
        ;;
      *)
        echo "Unknown onclick target: ${target}" >&2
        exit 2
        ;;
    esac
    ;;
  *)
    echo "Usage: $0 onclick powerrmenu" >&2
    exit 2
    ;;
esac
