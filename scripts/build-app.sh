#!/bin/bash
set -euo pipefail

# Builds Cafezim.app bundle from the Swift package

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_DIR/build"
APP_DIR="$BUILD_DIR/Cafezim.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

CONFIG="${1:-release}"
VERSION="${2:-}"

echo "Building Cafezim ($CONFIG)..."
cd "$PROJECT_DIR"
swift build -c "$CONFIG"

echo "Creating app bundle..."
rm -rf "$APP_DIR"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"

# Copy binary
cp ".build/$CONFIG/Cafezim" "$MACOS_DIR/Cafezim"

# Copy Info.plist
cp "Cafezim/Resources/Info.plist" "$CONTENTS_DIR/Info.plist"

# Inject version (strip leading "v" from tags like v1.3.0)
if [ -n "$VERSION" ]; then
    CLEAN_VERSION="${VERSION#v}"
    echo "Setting bundle version to $CLEAN_VERSION"
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $CLEAN_VERSION" "$CONTENTS_DIR/Info.plist"
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $CLEAN_VERSION" "$CONTENTS_DIR/Info.plist"
fi

# Copy icon if it exists
if [ -f "Cafezim/Resources/AppIcon.icns" ]; then
    cp "Cafezim/Resources/AppIcon.icns" "$RESOURCES_DIR/AppIcon.icns"
fi

echo "Built: $APP_DIR"
