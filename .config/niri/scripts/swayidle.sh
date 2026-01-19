# ~/.config/niri/scripts/swayidle.sh
#!/bin/bash
swayidle -w \
    timeout 120 'brightnessctl -s set 10%' \
    resume 'brightnessctl -r && killall swayidle ; ~/.config/niri/scripts/swayidle.sh &' \
    timeout 180 "$HOME/.config/swaylock/swaylock-wal.sh" \
    timeout 300 'niri msg action power-off-monitors' \
    resume 'niri msg action power-on-monitors' \
    before-sleep "$HOME/.config/swaylock/swaylock-wal.sh &"

