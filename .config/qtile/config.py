from libqtile.config import Key
from libqtile.lazy import lazy

from keys import keys, mod
from groups import groups
from layouts import layouts
from bar import screens
from rules import floating_layout
import autostart 

# Add group keybindings HERE (safe place)
for group in groups:
    keys.extend([
        Key([mod], group.name, lazy.group[group.name].toscreen()),
        Key([mod, "shift"], group.name, lazy.window.togroup(group.name, switch_group=True)),
        Key([mod, "control"], group.name, lazy.window.togroup(group.name)),
    ])

widget_defaults = dict(
    font="JetBrainsMono Nerd Font",
    fontsize=12,
    padding=3,
)

extension_defaults = widget_defaults.copy()
