from libqtile.config import Group

group_defs = [
    ("1", "󰲠"), # 󰎤
    ("2", "󰲢"), # 󰎧
    ("3", "󰲤"), # 󰎪
    ("4", "󰲦"), # 󰎭
    ("5", "󰲨"), # 󰎱
    ("6", "♥"),
    ("7", ""), #󰠓
    ("8", ""), #
    ("9", ""), #
    ("0", ""), #
    ("minus", "󱠇"),
    ("equal", ""),
]

groups = [Group(name, label=label) for name, label in group_defs]
