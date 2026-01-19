from libqtile import layout
from libqtile.config import Match
import colors

floating_layout = layout.Floating(
    border_width=3,
    border_focus=colors.BOR_FOC,
    border_normal=colors.BOR_NOR,
    float_rules=[
        *layout.Floating.default_float_rules,

        # Common utilities
        Match(wm_class="pavucontrol"),
        Match(wm_class="blueman-manager"),
        Match(wm_class="eog"),
        Match(wm_class="GParted"),
        Match(wm_class="galculator"),
        Match(wm_class="Timeshift-gtk"),

        # Picture-in-picture
        Match(title="Picture in picture"),

        # XDG Desktop Portal (all backends)
        Match(wm_class="xdg-desktop-portal"),
        Match(wm_class="xdg-desktop-portal-gtk"),
        Match(wm_class="xdg-desktop-portal-kde"),

        # Generic dialog fallbacks
        Match(wm_type="dialog"),
        Match(wm_type="utility"),
    ],
)

