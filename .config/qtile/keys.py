from libqtile.config import Key
from libqtile.lazy import lazy


@lazy.function
def window_to_relative_group(qtile, offset):
    groups = qtile.groups
    current = qtile.current_group
    idx = groups.index(current)
    target = groups[(idx + offset) % len(groups)]

    win = qtile.current_window
    if win:
        win.togroup(target.name, switch_group=True)


from libqtile.lazy import lazy


@lazy.function
def smart_resize(qtile, direction, amount=40):
    win = qtile.current_window
    layout = qtile.current_layout

    if not win:
        return

    # ────────────────
    # Floating windows
    # ────────────────
    if win.floating:
        dx = dy = 0
        if direction == "left":
            dx = -amount
        elif direction == "right":
            dx = amount
        elif direction == "up":
            dy = -amount
        elif direction == "down":
            dy = amount

        win.cmd_resize_floating(dx, dy)
        return

    # ────────────────
    # Tiled layouts
    # ────────────────

    # MonadTall / MonadWide
    if layout.name in ("monadtall", "monadwide"):
        if direction in ("left", "down"):
            layout.cmd_shrink()
        elif direction in ("right", "up"):
            layout.cmd_grow()
        return

    # Spiral
    if layout.name == "spiral":
        if direction in ("left", "down"):
            layout.cmd_shrink()
        elif direction in ("right", "up"):
            layout.cmd_grow()
        return

    # Max or unknown layouts → do nothing (intentionally)


@lazy.function
def focus_by_state(qtile, floating=False, direction=1):
    group = qtile.current_group
    if not group:
        return

    windows = [
        w for w in group.windows
        if w.floating == floating
    ]

    if not windows:
        return

    current = qtile.current_window

    # Jump into the target pool if needed
    if current not in windows:
        target = windows[0]
    else:
        idx = windows.index(current)
        target = windows[(idx + direction) % len(windows)]

    target.focus(warp=False)

    # 🔥 auto-raise floating windows
    if target.floating:
        target.bring_to_front()

        
mod = "mod4"
mod1 = "mod1"

keys = [
    Key([mod], "Return", lazy.spawn("kitty")),
    Key([mod, "shift"], "Return", lazy.spawn("alacritty")),
    Key([mod], "q", lazy.window.kill()),

    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),

    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),

    Key([mod], "space", lazy.next_layout()),
    Key([mod, "control"], "r", lazy.reload_config()),
    Key([mod], "r", lazy.spawncmd()),
    Key([mod1], "space", lazy.spawn("rofi -show drun -theme ~/X11Scripts/rofi/colors-rofi-dark.rasi -font 'JetBrains Mono 16'")),
    Key([mod1 , "control"], "delete", lazy.spawn("sh -c ~/X11Scripts/scripts/powermenu.sh")),
        Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume 0 +5%"),
        desc="Volume Up",
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume 0 -5%"),
        desc="volume down",
    ),
    Key(
        [], "XF86AudioMute", lazy.spawn("pulsemixer --toggle-mute"), desc="Volume Mute"
    ),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause"), desc="playerctl"),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous"), desc="playerctl"),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next"), desc="playerctl"),
    Key(
        [],
        "XF86MonBrightnessUp",
        lazy.spawn("brightnessctl s 10%+"),
        desc="brightness UP",
    ),
    Key(
        [],
        "XF86MonBrightnessDown",
        lazy.spawn("brightnessctl s 10%-"),
        desc="brightness Down",
    ),
        Key(
        [mod1 , "control"],
        "bracketright",
        lazy.spawn("brightnessctl s 10%+"),
        desc="brightness UP",
    ),
    Key(
        [mod1 , "control"],
        "bracketleft",
        lazy.spawn("brightnessctl s 10%-"),
        desc="brightness Down",
    ),
    Key(
        [mod],
        "e",
        lazy.spawn("pcmanfm"),
        desc="open file man",
    ),
    Key(
        [mod],
        "b",
        lazy.spawn("zen-browser"),
        desc="my browser",
    ),
    Key(
        [mod, "shift"],
        "b",
        lazy.spawn("brave"),
        desc="my browser",
    ),
    Key(
        [mod],
        "c",
        lazy.spawn("code"),
        desc="code",
    ),
    Key([mod], "Left", lazy.layout.left()),
    Key([mod], "Right", lazy.layout.right()),
    Key([mod], "Down", lazy.layout.down()),
    Key([mod], "Up", lazy.layout.up()),
    Key([mod1], "Tab", lazy.layout.next(),
        desc="Move Window Focus to Other Window"),
    Key([mod, "control"], "Left", lazy.layout.shuffle_left(),
        desc="Move window to the left",),
    Key([mod, "control"], "Right", lazy.layout.shuffle_right(),
        desc="Move window to the right",),
    Key([mod, "control"], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "control"], "k", lazy.layout.shuffle_up(),
        desc="Move window up"),
    # Key([mod, mod1], "Left", lazy.layout.grow_left(), desc="Grow window to the left"),
    # Key([mod, mod1], "Right", lazy.layout.grow_right(), desc="Grow window to the right"),
    # Key([mod, mod1], "Down", lazy.layout.grow_down(), desc="Grow window down"),
    # Key([mod, mod1], "Up", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod, "mod1"], "Left",
        smart_resize("left"),
        desc="Smart resize left",
    ),
    Key([mod, "mod1"], "Right",
        smart_resize("right"),
        desc="Smart resize right",
    ),
    Key([mod, "mod1"], "Up",
        smart_resize("up"),
        desc="Smart resize up",
    ),
    Key([mod, "mod1"], "Down",
        smart_resize("down"),
        desc="Smart resize down",
    ),

    Key([mod, mod1], "0", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod1], "Return", lazy.window.toggle_fullscreen()),
    Key([mod], "a", lazy.window.toggle_floating(),
        desc="float or tile"),

    Key([mod, "shift"], "Left", window_to_relative_group(-1),
        desc="Send window to previous workspace"),
    Key([mod, "shift"], "Right", window_to_relative_group(1),
        desc="Send window to next workspace"),
    Key(
        [mod1],
        "Tab",
        focus_by_state(floating=False, direction=1),
        desc="Cycle tiled windows",
    ),
    Key(
        [mod],
        "Tab",
        focus_by_state(floating=True, direction=1),
        desc="Cycle floating windows",
    ),
    Key(
        [mod, "shift"],
        "Tab",
        focus_by_state(floating=True, direction=-1),
    ),
    Key(
        [mod1, "shift"],
        "Tab",
        focus_by_state(floating=False, direction=-1),
    ),
    Key(
        [mod],
        "t",
        lazy.spawn("sh -c ~/X11Scripts/themer.sh")
    ),
    Key(
        [mod1, "control"],
        "w",
        lazy.spawn("sh -c '~/X11Scripts/wallpaper.sh switcher'")
    ),
    Key(
        [mod, "shift"],
        "s",
        lazy.spawn("sh -c 'X11Scripts/scripts/scrnsht.sh'")
    ),
]

