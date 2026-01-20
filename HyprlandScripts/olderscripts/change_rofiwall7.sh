
#!/bin/bash

# Path to the rofi style file (adjust if needed)
ROFI_STYLE_FILE="$HOME/.config/rofi/type-7/style-7.rasi"
ROFI_STYLE_FILE2="$HOME/HyprlandScripts/style-10.rasi"

# Path to the wal cache file
WAL_CACHE_FILE="$HOME/.cache/wal/wal"

# Check if the wal cache file exists
if [ ! -f "$WAL_CACHE_FILE" ]; then
    echo "Error: The wal cache file '$WAL_CACHE_FILE' does not exist."
    exit 1
fi

# Get the wallpaper path from the wal cache file
WALLPAPER_PATH=$(cat "$WAL_CACHE_FILE")

# Check if the wallpaper path is valid
if [ -z "$WALLPAPER_PATH" ]; then
    echo "Error: The wal cache file '$WAL_CACHE_FILE' is empty or contains no valid wallpaper path."
    exit 1
fi

# Debugging: print the wallpaper path
echo "Wallpaper path: $WALLPAPER_PATH"

# Use sed to replace the 'background-image' line with the new wallpaper path
sed -i "s|background-image:.*|background-image: url(\"$WALLPAPER_PATH\",width);|" "$ROFI_STYLE_FILE"
sed -i "s|background-image:.*|background-image: url(\"$WALLPAPER_PATH\",height);|" "$ROFI_STYLE_FILE2"

# Check if the sed operation was successful
if [ $? -eq 0 ]; then
  {
    echo "Successfully updated the wallpaper path in '$ROFI_STYLE_FILE2'."
    echo "Successfully updated the wallpaper path in '$ROFI_STYLE_FILE'."
  } 
else
    echo "Error: Failed to update the wallpaper path."
    exit 1
fi
