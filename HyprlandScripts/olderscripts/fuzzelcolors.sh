#!/bin/bash

# Define the path to the fuzzeledited.ini and colors.css files
INI_FILE="$HOME/.config/fuzzel/fuzzeledited.ini"
CSS_FILE="$HOME/.cache/wal/colors.css"

# Function to extract color values from the colors.css file
get_color_value() {
    local color_var=$1
    # Extract the color value and append 'ff' by default
    local color=$(grep -oP "(?<=--${color_var}:)[[:space:]]*#[0-9a-fA-F]{6}" "$CSS_FILE" | tr -d '[:space:]')
    if [[ "$color_var" == "background" ]]; then
        # Append 'aa' for background instead of 'ff'
        echo "${color}aa"
    else
        # Append 'ff' for all other colors
        echo "${color}ff"
    fi
}

# Extract the colors from the CSS file and append the appropriate suffix ('aa' or 'ff')
background=$(get_color_value "background")
text=$(get_color_value "foreground")
match=$(get_color_value "color4") # Assuming match corresponds to --color9
selection=$(get_color_value "color4") # Assuming selection corresponds to --color7
selection_text=$(get_color_value "color15") # Assuming selection-text corresponds to --color8
border=$(get_color_value "color4") # Assuming border corresponds to --color4

# Function to update the value in the INI file
update_ini() {
    local key=$1
    local value=$2
    sed -i "s/^${key}=.*/${key}=${value}/" "$INI_FILE"
}

# Update the colors in the INI file
update_ini "background" "$background"
update_ini "text" "$text"
update_ini "match" "$match"
update_ini "selection" "$selection"
update_ini "selection-text" "$selection_text"
update_ini "border" "$border"

echo "Colors updated successfully in $INI_FILE"

