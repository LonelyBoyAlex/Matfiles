
#!/bin/bash

# Path to the colors file and style.css
colors_file="$HOME/.cache/wal/colors"
style_file="$HOME/.config/wlogout/style.css"

# Read colors into an array
mapfile -t colors < "$colors_file"

# Check if there are enough colors
if [ ${#colors[@]} -lt 14 ]; then  # Adjusted to check for at least 14
    echo "Error: Not enough colors in $colors_file."
    exit 1
fi

# Define new color values based on available colors
btn_color="${colors[0]}"         # Button text color
bg_color_1="${colors[1]}"        # First background color
bg_color_2="${colors[2]}"        # Second background color
focus_color="${colors[3]}"       # Focus color
hover_color_1="${colors[4]}"     # First hover color
hover_color_2="${colors[5]}"     # Second hover color

# Create a backup of the original style.css
cp "$style_file" "$style_file.bak"

# Update style.css with the new colors
sed -i "s/#FFFFFbtn_color/g" "$style_file" && echo "Button color updated."
sed -i "s/#101213/$bg_color_1/g" "$style_file" && echo "Background color 1 updated."
sed -i "s/#5a4b6d/$bg_color_2/g" "$style_file" && echo "Background color 2 updated."
sed -i "s/#7B9E95/$focus_color/g" "$style_file" && echo "Focus color updated."
sed -i "s/#8CA799/$hover_color_1/g" "$style_file" && echo "Hover color 1 updated."
sed -i "s/#DE6D2A/$hover_color_2/g" "$style_file" && echo "Hover color 2 updated."

echo "Updated logout-menu colors."
