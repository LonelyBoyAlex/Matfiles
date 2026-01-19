#!/usr/bin/env sh

# Set variables
scrDir="$(dirname "$(realpath "$0")")"
woconf="$HOME/.config/wofi/style.rasi"

# Wofi action
case "${1}" in
    d|--drun) w_mode="drun" ;; 
    w|--window) w_mode="window" ;;
    f|--filebrowser) w_mode="filebrowser" ;;
    h|--help) 
        echo -e "$(basename "${0}") [action]"
        echo "d :  drun mode"
        echo "w :  window mode"
        echo "f :  filebrowser mode"
        exit 0 ;;
    *) w_mode="drun" ;;  # Default to drun mode if no valid action is provided
esac

# Run the color script to update style if needed
$HOME/HyprlandScripts/wofi-colors.sh

# Launch wofi
wofi --show "${w_mode}" --style="${woconf}" &

# Wait for a moment to ensure wofi has started
sleep 0.1

# Use Hyprland commands to maximize the wofi window
# This command assumes wofi is the last window created
hyprctl dispatch window toggle_maximize
