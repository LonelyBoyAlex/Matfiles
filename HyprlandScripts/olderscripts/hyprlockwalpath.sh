
#!/bin/bash

#this script changes the path of current wallpaper path in hyprlock.conf

# Define file paths
WAL_FILE="$HOME/.cache/wal/wal"
HYPRLOCK_CONF="$HOME/.config/hypr/hyprlock.conf"

# Check if the WAL file exists
if [[ ! -f "$WAL_FILE" ]]; then
    echo "WAL file not found: $WAL_FILE"
    exit 1
fi

# Read the contents of the WAL file and remove the trailing '%' character
WAL_CONTENT=$(<"$WAL_FILE")
WAL_CONTENT="${WAL_CONTENT/%/}"  # Remove trailing '%'

# Update hyprlock.conf
# Replace only the path part of the line in the background section
sed -i.bak -E "s|^ +path *=.*|    path = $WAL_CONTENT|" "$HYPRLOCK_CONF"

echo "Updated hyprlock.conf with the new wallpaper path."
