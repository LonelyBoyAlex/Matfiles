#!/bin/bash

# Define paths
colors_file="$HOME/.cache/wal/colors-rofi-dark.rasi"
rofi_colors="$HOME/.config/rofi/roficolors.rasi"

# Extract colors from colors-rofi-dark.rasi
background=$(grep -m 1 "background:" "$colors_file" | awk '{print $2}')
foreground=$(grep -m 1 "foreground:" "$colors_file" | awk '{print $2}')
border_color=$(grep -m 1 "border-color:" "$colors_file" | awk '{print $2}')

# Populate roficolors.rasi
cat > "$rofi_colors" <<EOL
* {
    @background: $background;
    @foreground: $foreground;
    @border-color: $border_color;
}
EOL

echo "roficolors.rasi updated!"

