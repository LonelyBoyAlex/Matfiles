#!/usr/bin/env sh

# Set the path for the colors and style files
colors_file="$HOME/.cache/wal/colors.css"
style_file="$HOME/.config/wofi/style.rasi"

# Check if colors.css exists
if [ ! -f "$colors_file" ]; then
    echo "Colors file not found: $colors_file"
    exit 1
fi

# Extract colors from colors.css
bg_color=$(grep -oP '(?<=--background: )[^;]+' "$colors_file")
fg_color=$(grep -oP '(?<=--foreground: )[^;]+' "$colors_file")
color0=$(grep -oP '(?<=--color0: )[^;]+' "$colors_file")
color1=$(grep -oP '(?<=--color1: )[^;]+' "$colors_file")
color2=$(grep -oP '(?<=--color2: )[^;]+' "$colors_file")
color3=$(grep -oP '(?<=--color3: )[^;]+' "$colors_file")
color4=$(grep -oP '(?<=--color4: )[^;]+' "$colors_file")
color5=$(grep -oP '(?<=--color5: )[^;]+' "$colors_file")
color6=$(grep -oP '(?<=--color6: )[^;]+' "$colors_file")
color7=$(grep -oP '(?<=--color7: )[^;]+' "$colors_file")
selected_bg_color="$color3"  # Use color3 for selected background
hover_bg_color="$color5"      # Use color5 for hover background

# Create or overwrite the style.rasi file
cat << EOF > "$style_file"
* {
    background-color: $bg_color; /* Background color */
    color: $fg_color; /* Text color */
}

window {
    background-color: $color0; /* Window background */
    border: 2px solid $color1; /* Window border */
    border-radius: 5px; /* Window border radius */
}

element {
    background-color: $color0; /* Element background */
    border: 1px solid $color1; /* Element border */
    border-radius: 5px; /* Element border radius */
}

element.selected {
    background-color: $selected_bg_color; /* Selected element background */
    color: $fg_color; /* Selected element text color */
}

element:hover {
    background-color: $hover_bg_color; /* Hover background */
    color: $fg_color; /* Hover text color */
}

#font {
    font: "JetBrainsMono Nerd Font" 10; /* Adjust font as needed */
}
EOF

echo "Wofi style configuration updated at $style_file"
