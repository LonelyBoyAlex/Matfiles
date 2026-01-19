#!/usr/bin/env bash

# Set working directories
dir="$HOME/X11Scripts"
theme_dir="$HOME/X11Scripts/themes"
dunst_conf_dir="$HOME/.config/dunst/dunstrc.d"
wal_cmd=""

# --- 1. SELECT THEME (PIPED DIRECTLY TO ROFI) ---
# We run the loop inside a subshell and pipe output directly to rofi
# This avoids string formatting issues with null bytes
theme=$(
    for direc in "$theme_dir"/*/; do
        theme_name=$(basename "$direc")
        
        # FIX: Check strictly case-insensitive to ensure "Thumbnails" is skipped
        if [[ "${theme_name,,}" == "thumbnails" ]]; then
            continue
        fi
        
        # Path to the thumbnail image
        preview="$theme_dir/thumbnails/$theme_name.png"
        
        if [[ -f "$preview" ]]; then
            # FIX: Use printf with \x00 for the null byte. Safer than echo.
            # Format: Name + Null + icon + UnitSeparator + Path + Newline
            printf "%s\x00icon\x1f%s\n" "$theme_name" "$preview"
        else
            printf "%s\n" "$theme_name"
        fi
    done | rofi -dmenu -i -theme "$dir/rofi/themer.rasi" -p "Select theme: " -show-icons
)

# Exit if no theme selected or invalid directory
[ -z "$theme" ] || [ ! -d "$theme_dir/$theme" ] && exit 1

# --- 2. WALLPAPER SYMLINK ---
# Only create symlink if theme has wallpapers folder
[ -d "$theme_dir/$theme/wallpapers" ] || { notify-send "No wallpapers in $theme"; exit 1; }

# 'ln -sfn' forces the link update cleanly
ln -sfn "$theme_dir/$theme/wallpapers" "$dir/wallpapers"

# --- 3. COPY CONFIGS (EXCLUDING WALLPAPERS) ---
rsync -av --exclude='wallpapers/' "$theme_dir/$theme/" "$dir/"

# --- 4. DUNST CONFIG SYMLINK ---
mkdir -p "$dunst_conf_dir"

if [ -f "$theme_dir/$theme/colors/zdunstcolors.conf" ]; then
    ln -sf "$theme_dir/$theme/colors/zdunstcolors.conf" "$dunst_conf_dir/zdunstcolors.conf"
    
    # Reload dunst
    pgrep -x dunst >/dev/null && killall dunst
    dunst &
else
    notify-send "Warning: No zdunstcolors.conf found for $theme"
fi

# --- 4.2 qtile CONFIG SYMLINK ---
#if [[ "${XDG_SESSION_DESKTOP,,}" == "qtile" ]]; then    
#    mkdir -p "$HOME/.config/qtile"

#    if [ -f "$theme_dir/$theme/colors/colors.py" ]; then
        ln -sf "$dir/colors/colors.py" "$HOME/.config/qtile/colors.py"
        qtile cmd-obj -o cmd -f reload_config
#    else
#        notify-send "Warning: No COLORS.PY found for $theme"
#    fi
#fi

# --- 5. WAL THEME LOGIC ---
case "$theme" in
    "Everforest")
        wal_cmd="wal --theme forest-dark"
        ;;
    "everREst")
        wal_cmd="wal --theme sexygreen"
        ;;
    "MonoBlack")
        wal_cmd="wal --theme base16-grayscale"
        ;;
    "Nord")
        wal_cmd="wal --theme base16-nord"
        ;;
    "Tokyonight")
        wal_cmd="wal --theme TN-x"
        #wal_cmd="wal --theme tokyonight-moon"
        ;;
    "Rosepine")
        wal_cmd="wal --theme rose-pine-moon"
        ;;
    "Gruvbox")
        wal_cmd="wal --theme base16-gruvbox-soft"
        ;;
    *)
        notify-send "No wal theme mapped for '$theme'" && exit 1
        ;;
esac

eval "$wal_cmd"

# --- 6. APPLY WALLPAPER & SAVE STATE ---
"$HOME/X11Scripts/wallpaper.sh" random

notify-send "Theme '$theme' applied!"
echo "$theme" > "$dir/current_theme"
