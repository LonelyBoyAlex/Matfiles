#!/usr/bin/env bash
set -e

app_dir="/usr/share/applications"
user_app_dir="$HOME/.local/share/applications"
cache="$HOME/.cache/eww-apps.json"

tmp_file="$(mktemp)"

printf "[" > "$tmp_file"
first=1

for file in "$app_dir"/*.desktop "$user_app_dir"/*.desktop; do
    [ -e "$file" ] || continue

    name=$(grep -m1 "^Name=" "$file" | cut -d= -f2)
    exec=$(grep -m1 "^Exec=" "$file" | sed 's/^Exec=//; s/%[a-zA-Z]//g')

    [ -n "$name" ] && [ -n "$exec" ] || continue

    # Create JSON object on a single line
    json=$(jq -c -n --arg name "$name" --arg exec "$exec" \
              '{name:$name, exec:$exec}')

    if [ $first -eq 0 ]; then
        printf "," >> "$tmp_file"
    fi
    first=0

    printf "%s" "$json" >> "$tmp_file"
done

printf "]" >> "$tmp_file"

mv "$tmp_file" "$cache"

