from libqtile import bar, widget, qtile
from libqtile.config import Screen
from libqtile.widget import backlight
from libqtile.lazy import lazy
# from libqtile.widget import Mpd2
import colors
import re

BG = colors.BG
ACCENT = colors.ACCENT
MID = colors.MID
FG = colors.FG
#BG = "#2e3440"
#ACCENT = "#88c0d0"
#MID = "#3b4252"
SEPFNT = "28"

#custom music player
import subprocess

def now_playing():
    try:
        # Get both title and artist in one call
        output = subprocess.check_output(
            ["playerctl", "metadata", "--format", "{{ title }}||{{ artist }}"],
            stderr=subprocess.DEVNULL,
            text=True,
        ).strip()

        if not output or output.startswith("org.mpris.MediaPlayer2"):  # nothing playing
            return " 󰽱 NoT PLaYinG 󰽱 "

        title, artist = output.split("||")
        # Build string with optional artist
        text = f" {title} – {artist}" if artist else f" {title}"
        # Trim to 35 chars
        return text[:35]

    except Exception:
            return " 󰽱 NoT PLaYinG 󰽱 "


#CUSTOM TITLE
def format_title(text):
    # Split string by " - " (hyphen), " — " (em-dash), or " | " (pipe)
    parts = re.split(r" - | — | \| ", text)
    
    # Optional: Clean up whitespace for each part
    parts = [p.strip() for p in parts]
    
    # Reverse the list so the App Name (usually last) comes first
    # e.g., ["Video", "YouTube", "Zen Browser"] -> ["Zen Browser", "YouTube", "Video"]
    reversed_parts = parts[::-1]
    
    # Join them back with a standard hyphen
    return " - ".join(reversed_parts)


screens = [
    Screen(
#        bottom=bar.Bar(
        top=bar.Bar(
            [
                widget.TextBox(
                    text=" 󰣇 ",
                    fontsize=24,
                    padding=10,
                    foreground=BG,
                    background=MID,
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(
                        "rofi -show drun -theme X11Scripts/rofi/colors-rofi-dark.rasi -font 'mono 16'"
                        ),
                    },
                ),
                widget.TextBox(
                    text="",
                    fontsize=SEPFNT,
                    padding=0,
                    foreground=MID,
                    background=BG,
                ),
                widget.GroupBox(
                    # visible_groups=["1", "2", "3", "4", "5"],
                    hide_unused=True,
                    rounded=True,
                    highlight_method="block", # border block text line 
                    active=MID,
                    # inactive=,
                    this_current_screen_border=MID,
                    block_highlight_text_color=BG,
                    # background=BG,
                    # foreground=FG,
                    fontsize=24,
                    padding_x=8,
                    center_aligned=True,
                    font='JetBrains Mono Nerd Font Propo'
                    # borderwidth=2,
                    # border='ffffff',
                ),

                # >
                widget.TextBox(
                    text="",
                    fontsize=SEPFNT,
                    padding=0,
                    foreground=MID,
                    background=BG,
                ),

                widget.WindowName(
                    # format='{name}',
                    parse_text=format_title,
                    background=MID,
                    foreground=BG,
                    fontsize=16,
                    padding=6,
                    empty_group_string='Qtile Rocks!!',
                    max_chars=40
                ),
                widget.TextBox(
                    text="", #
                    fontsize=SEPFNT,
                    padding=0,
                    background=FG,
                    foreground=MID,
                ),
                # widget.Spacer(background=BG),
                widget.Clock(
                    format="   %a %d%b  <span weight='heavy' size='120%'> %H:%M</span>  ", #   
                    padding=10,
                    fontsize=16,
                    background=FG,
                    foreground=ACCENT,
                    markup=True
                ),
                # widget.Spacer(background=BG),
                                
                # >
                widget.TextBox(
                    text="", #
                    fontsize=SEPFNT,
                    padding=0,
                    foreground=MID,
                    background=FG,
                ),
                # widget.Mpris2(
                #     background=MID,
                #     foreground=ACCENT,
                #     fontsize=15,
                #     padding=8,
                #     max_chars=40,
                #     display_metadata=["xesam:title", "xesam:artist"],
                #     scroll=True,
                #     scroll_interval=0.5,
                #     stopped_text="",
                # ),
                # widget.Mpd2(
                #     idle_format='NoT PLaYinG'
                # ),
                widget.GenPollText(
                func=now_playing,
                update_interval=2,
                background=MID,
                foreground=BG,
                fontsize=15,
                padding=8,),

                widget.TextBox(
                    text="",
                    fontsize=SEPFNT,
                    padding=0,
                    foreground=MID,
                    background=BG,
                    # font='Hermit Nerd Font Propo'
                ),
                widget.Backlight(
                    # name="backlight",
                    #backlight_name="intel_backlight",  # replace with your device
                    format=" ☀ {percent:2.0%}",    
                    change_command="brightnessctl set {}%",
                    step=3,
                    min_brightness=5,
                    fontsize=16,
                    padding=8,
                    background=BG,
                    foreground=MID,    
                    mouse_callbacks={
                        "Button4": lambda: qtile.widgets_map["backlight"].change_backlight(
                            backlight.ChangeDirection.UP
                        ),
                        "Button5": lambda: qtile.widgets_map["backlight"].change_backlight(
                            backlight.ChangeDirection.DOWN
                        ),
                    },              
                ),
                widget.Volume(
                    fmt=" 󱄠 {} ",
                    background=BG,
                    foreground=MID,
                    fontsize=16,
                    # mouse_callbacks={
                    #     "Button4": lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
                    #     "Button5": lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
                    #     "Button2": lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
                    # },
                ),

                widget.TextBox(
                    text="",
                    fontsize=SEPFNT,
                    padding=0,
                    foreground=MID,
                    background=BG,
                    # font='Hermit Nerd Font Propo'
                ),
                widget.CPU(
                    format="  {load_percent:02.0f}%  ",
                    # format=" 󰍛  {load_percent:02.0f}%",
                    foreground=BG,
                    background=MID,
                    fontsize=16,
                    padding=0,
                ),
                widget.Memory(
                    format="  {MemPercent:02.0f}% ",
                    # format="  󰍛 {MemUsed:.0f}{mm}",
                    foreground=BG,
                    background=MID,
                    fontsize=16,
                    padding=0,
                ),

                # >
                widget.TextBox(
                    text="",
                    fontsize=SEPFNT,
                    padding=0,
                    foreground=MID,
                    background=BG,
                    # font='Hermit Nerd Font Propo'

                ),
                widget.Systray(
                    background=BG,
                    padding=10,
                    icon_size=20
                    ),
                widget.TextBox(
                    text=" ",
                    fontsize=SEPFNT,
                    padding=0,
                    foreground=MID,
                    background=BG,
                    # font='Hermit Nerd Font Propo'
                ),
                widget.TextBox(
                    text=" 󰤆 ",
                    fontsize=22,
                    padding=10,
                    foreground=BG,
                    background=MID,
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(
                        "~/qtileconf/scripts/powermenu.sh"
                        ),
                    },
                ),
            ],
            28,
            background=BG,
        )
    )
]
