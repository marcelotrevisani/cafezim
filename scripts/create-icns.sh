#!/bin/bash
set -euo pipefail

# Creates an .icns file from the SVG logo
# Requires: rsvg-convert (brew install librsvg) or sips

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SVG_PATH="$PROJECT_DIR/assets/cafezim-mineiro.svg"
ICONSET_DIR="$PROJECT_DIR/build/AppIcon.iconset"
ICNS_PATH="$PROJECT_DIR/Cafezim/Resources/AppIcon.icns"

mkdir -p "$ICONSET_DIR"

# Generate PNG at the required sizes
sizes=(16 32 64 128 256 512)
for size in "${sizes[@]}"; do
    if command -v rsvg-convert &>/dev/null; then
        rsvg-convert -w "$size" -h "$size" "$SVG_PATH" > "$ICONSET_DIR/icon_${size}x${size}.png"
        double=$((size * 2))
        rsvg-convert -w "$double" -h "$double" "$SVG_PATH" > "$ICONSET_DIR/icon_${size}x${size}@2x.png"
    elif command -v sips &>/dev/null; then
        # Fallback: use sips with a temporary PNG
        # First create a large PNG using a Python one-liner if available
        echo "Warning: rsvg-convert not found. Install with: brew install librsvg"
        echo "Falling back to sips (may not handle SVG well)"
        exit 1
    fi
done

# Create .icns from the iconset
iconutil -c icns "$ICONSET_DIR" -o "$ICNS_PATH"
echo "Created $ICNS_PATH"

# Cleanup
rm -rf "$ICONSET_DIR"
