# #!/usr/bin/env bash

# if [[ $XDG_CURRENT_DESKTOP == "Hyprland" ]]; then
#     case "$1" in
#         up)
#             hyprctl dispatch workspace r+1
#             ;;
#         down)
#             hyprctl dispatch workspace r-1
#             ;;
#         *)
#             hyprctl dispatch workspace "$1"
#             ;;
#     esac

# elif [[ $XDG_CURRENT_DESKTOP == "niri" ]]; then
#         case "$1" in
#         up)
#             niri msg action focus-workspace-up
#             ;;
#         down)
#             niri msg action focus-workspace-down
#             ;;
#         *)
#             niri msg action focus-workspace "$1"
#             ;;
#     esac

# else
#     exit 0
# fi

#!/usr/bin/env bash
# Switch workspace for Hyprland, Niri, or MangoWC
# Usage: ./switch-workspaces.sh <up|down|N>

if [[ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]]; then
    case "$1" in
        up) hyprctl dispatch workspace r+1 ;;
        down) hyprctl dispatch workspace r-1 ;;
        *) hyprctl dispatch workspace "$1" ;;
    esac

elif [[ "$XDG_CURRENT_DESKTOP" == "Niri" ]]; then
    case "$1" in
        up) niri msg action focus-workspace-up ;;
        down) niri msg action focus-workspace-down ;;
        *) niri msg action focus-workspace "$1" ;;
    esac

elif [[ "$XDG_CURRENT_DESKTOP" == "mango" ]]; then
    # Get only the first active workspace
    ACTIVE=$(mmsg -g -t | awk '/tag/ && $4==1 { print $3; exit }')
    ACTIVE=${ACTIVE:-1}  # fallback to 1

    case "$1" in
        up) NEXT=$((ACTIVE + 1)) ;;
        down) NEXT=$((ACTIVE - 1)) ;;
        *) NEXT="$1" ;;
    esac

    mmsg -t "$NEXT"

else
    exit 0
fi
