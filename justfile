# Build in debug mode
debug:
    swift build

# Build in release mode
release:
    swift build -c release

# Run the app in the background
run: debug
    .build/debug/Cafezim &

# Run all tests
test:
    swift test

# Format Swift source files
format:
    swiftformat .

# Build Cafezim.app bundle (default: release)
app config="release":
    ./scripts/build-app.sh {{ config }}

# Build DMG installer (default version: dev)
dmg version="dev":
    ./scripts/build-dmg.sh {{ version }}

# Generate .icns icon from SVG (requires librsvg)
icon:
    ./scripts/create-icns.sh
