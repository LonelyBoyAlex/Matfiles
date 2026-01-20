#!/bin/bash

# Path to the Pywal colors.css file
WAL_COLORS_FILE="$HOME/.cache/wal/colors.css"

# Extract colors using grep and sed
color0=$(grep --color=never "color0:" $WAL_COLORS_FILE | sed 's/.*: //;s/;.*//')
color1=$(grep --color=never "color1:" $WAL_COLORS_FILE | sed 's/.*: //;s/;.*//')
color2=$(grep --color=never "color2:" $WAL_COLORS_FILE | sed 's/.*: //;s/;.*//')
color7=$(grep --color=never "color7:" $WAL_COLORS_FILE | sed 's/.*: //;s/;.*//')
color15=$(grep --color=never "color15:" $WAL_COLORS_FILE | sed 's/.*: //;s/;.*//')

# Create CSS file for Swaync
cat << EOF > ~/.config/swaync/swaync.css
* {
    background-color: rgba(${color1}, 0.8); /* Background with transparency */
    color: ${color0}; /* Default text color */
    border-radius: 8px; /* Rounded corners */
}

.notification {
    padding: 10px;
    margin: 5px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
}

.title {
    font-weight: bold;
    font-size: 1.1em;
    color: ${color7}; /* Title color */
}

.body {
    font-size: 0.9em;
    color: ${color0}; /* Body text color */
}

.button {
    background-color: rgba(${color2}, 0.8); /* Button background color */
    border-radius: 4px;
    padding: 5px 10px;
    color: ${color15}; /* Button text color */
}
EOF

echo "Swaync CSS generated at ~/.config/swaync/swaync.css"

