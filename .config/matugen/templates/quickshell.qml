pragma Singleton
import QtQuick

QtObject {
    property color bg: "{{colors.primary_container.default.hex}}"
    property color fg: "{{colors.on_primary_container.default.hex}}"
    property color accent: "{{colors.primary.default.hex}}"
    property color active: "{{colors.on_primary.default.hex}}"
    property color inactive: "{{colors.surface_variant.default.hex}}"
    property color dim: "{{colors.surface.default.hex}}"
}

