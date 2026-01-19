#!/usr/bin/env bash

# ACTIVE=1

# if [[ $XDG_CURRENT_DESKTOP == "Hyprland" ]]; then
#     ACTIVE=$(hyprctl activeworkspace -j | jq -r '.id')

#     # If workspace ID is between 6 and 10, subtract 5
#     if (( ACTIVE > 5 && ACTIVE <= 10 )); then
#         ACTIVE=$((ACTIVE - 5))
#     fi

#     if (( ACTIVE > 10 && ACTIVE <= 15 )); then
#         ACTIVE=$((ACTIVE - 10))
#     fi

# elif [[ $XDG_CURRENT_DESKTOP == "Niri" ]]; then
#     ACTIVE=$(niri msg -j workspaces | jq -r '.[] | select(.is_active) | .idx')

# else
#     exit 0
# fi

# echo "$ACTIVE"

#!/usr/bin/env bash
# Returns the currently active workspace for Hyprland, Niri, or MangoWC

ACTIVE=1

if [[ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]]; then
    ACTIVE=$(hyprctl activeworkspace -j | jq -r '.id')
    (( ACTIVE > 5 && ACTIVE <=10 )) && ACTIVE=$((ACTIVE-5))
    (( ACTIVE > 10 && ACTIVE <=15 )) && ACTIVE=$((ACTIVE-10))

elif [[ "$XDG_CURRENT_DESKTOP" == "Niri" ]]; then
    ACTIVE=$(niri msg -j workspaces | jq -r '.[] | select(.is_active) | .idx')

elif [[ "$XDG_CURRENT_DESKTOP" == "mango" ]]; then
    # Get only the first active workspace
    ACTIVE=$(mmsg -g -t | awk '/tag/ && $4==1 { print $3; exit }')
    ACTIVE=${ACTIVE:-1}  # fallback to 1

    # Map to 1-5 range
    ACTIVE=$(( ((ACTIVE - 1) % 5) + 1 ))
else
    exit 0
fi

echo "$ACTIVE"
