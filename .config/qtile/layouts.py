from libqtile import layout
import colors

# ─────────────────────────────
# Base theme (safe for ALL layouts)
# ─────────────────────────────
base = dict(
    border_width=4,
    margin=10,
    border_focus=colors.BOR_FOC,
    border_normal=colors.BOR_NOR,
    # border_focus="#88c0d0",
    # border_normal="#3b4252",
)

# ─────────────────────────────
# Layout-specific extensions
# ─────────────────────────────
monad = dict(
    change_ratio=0.03,   # left / right
    change_size=20,      # up / down (px)
)

spiral = dict(
    ratio=0.5,
    ratio_increment=0.05,
)

# ─────────────────────────────
# Layouts (only valid args passed)
# ─────────────────────────────
layouts = [
    layout.MonadTall(
        **base,
        **monad,
    ),
    #layout.MonadWide(
    #    **base,
    #    **monad,
   # ),
    layout.Spiral(
        **base,
        **spiral,
    ),
    layout.Max(
        **base,
    ),
]
