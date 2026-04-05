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
app config="release" version="":
    ./scripts/build-app.sh {{ config }} {{ version }}

# Build DMG installer (default version: dev)
dmg version="dev":
    ./scripts/build-dmg.sh {{ version }}

# Generate .icns icon from SVG (requires librsvg)
icon:
    ./scripts/create-icns.sh

# Install `cafezim` CLI launcher into PATH (default: /usr/local/bin)
install prefix="/usr/local/bin":
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p "{{ prefix }}"
    ln -sf "$(pwd)/scripts/cafezim" "{{ prefix }}/cafezim"
    echo "Installed: {{ prefix }}/cafezim -> $(pwd)/scripts/cafezim"

# Uninstall `cafezim` CLI launcher
uninstall prefix="/usr/local/bin":
    rm -f "{{ prefix }}/cafezim"
