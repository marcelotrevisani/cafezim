<p align="center">
  <img src="assets/cafezim-mineiro.svg" alt="Cafezim Mineiro" width="200" />
</p>

<h1 align="center">Cafezim Mineiro</h1>

<p align="center">
  A lightweight macOS menu bar app that keeps your Mac awake — no sleep, no screen dimming.
  <br />
  Like <em>Lungo</em>, <em>Caffeine</em>, and <em>Amphetamine</em>, but simpler.
</p>

---

## Install

### Homebrew

```bash
brew tap marceloduartetrevisani/tap
brew install --cask cafezim
```

### Manual

Download the latest `.dmg` from [Releases](https://github.com/marceloduartetrevisani/cafezim/releases), open it, and drag **Cafezim.app** to your Applications folder.

## Features

- Prevents your Mac from sleeping and the display from turning off
- Lives in the menu bar with a coffee cup icon (filled when active)
- Timer support: keep awake for 30min, 1h, 2h, 4h, 8h, or a custom number of hours
- Indefinite mode (default) — stays awake until you deactivate it
- Zero configuration, no Dock icon, minimal resource usage
- Uses native macOS IOKit power assertions (`IOPMAssertionCreateWithName`)

## Requirements (for building from source)

- macOS 13 (Ventura) or later
- Xcode 15+ (for building)
- [just](https://github.com/casey/just) (optional, for convenience commands)

## Building

### With just

```bash
# Debug build
just debug

# Release build
just release

# Build .app bundle (release by default)
just app

# Build .app bundle in debug mode
just app debug

# Build DMG installer
just dmg v0.1.0
```

### Without just

```bash
# Debug build
swift build

# Release build
swift build -c release

# Build .app bundle
./scripts/build-app.sh release

# Build DMG
./scripts/build-dmg.sh v0.1.0
```

The built artifacts will be located at:
- Debug binary: `.build/debug/Cafezim`
- Release binary: `.build/release/Cafezim`
- App bundle: `build/Cafezim.app`
- DMG: `build/Cafezim-<version>.dmg`

## Running

### With just

```bash
just run
```

This builds in debug mode and launches the app in the background.

### Without just

```bash
# Debug
swift build && .build/debug/Cafezim &

# Release
swift build -c release && .build/release/Cafezim &

# From .app bundle
open build/Cafezim.app
```

Once running, look for the coffee cup icon in your menu bar.

## Testing

### With just

```bash
just test
```

### Without just

```bash
swift test
```

> **Note:** Tests require the full Xcode installation (not just Command Line Tools).
> If you see `no such module 'XCTest'`, run:
> ```bash
> sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
> ```

## Formatting

```bash
# Format all Swift files
just format

# Pre-commit hook (auto-formats on commit)
brew install pre-commit swiftformat
pre-commit install
```

## How It Works

Cafezim uses macOS IOKit power assertions to prevent sleep:

- **`kIOPMAssertionTypeNoDisplaySleep`** — prevents both system sleep and display sleep
- When a timer is set, the assertion is automatically released when time expires
- Deactivating (or quitting) immediately releases the assertion

## Project Structure

```
cafezim/
├── Package.swift                  # Swift Package Manager config
├── justfile                       # Build/run/test shortcuts
├── Cafezim/
│   ├── Sources/
│   │   └── CafezimApp.swift       # App entry point, menu bar setup
│   └── Resources/
│       ├── Info.plist              # App bundle metadata
│       └── Entitlements.plist      # App entitlements
├── CafezimCore/
│   └── Sources/
│       ├── SleepManager.swift     # IOKit power assertion logic
│       └── MenuBarView.swift      # SwiftUI menu bar UI
├── CafezimTests/
│   ├── SleepManagerTests.swift    # Core logic tests
│   └── MenuBarViewTests.swift     # UI model tests
├── scripts/
│   ├── build-app.sh               # Builds Cafezim.app bundle
│   ├── build-dmg.sh               # Packages .app into a .dmg
│   └── create-icns.sh             # Generates .icns from SVG logo
└── .github/
    └── workflows/
        ├── ci.yml                 # CI: build + test on push/PR
        └── release.yml            # Release: DMG + Homebrew tap update
```

## Releasing

Releases are automated via GitHub Actions. When you publish a new release:

1. Tag your commit: `git tag v0.1.0 && git push origin v0.1.0`
2. Create a GitHub release from the tag
3. The pipeline automatically:
   - Runs tests
   - Builds `Cafezim.app` and packages it into a `.dmg`
   - Uploads the `.dmg` to the GitHub release
   - Updates the Homebrew cask formula in your tap repo

### One-time setup for Homebrew tap

1. Create the tap repo:
   ```bash
   gh repo create homebrew-tap --public
   ```

2. Create a fine-grained PAT with **Contents: Read and write** on `homebrew-tap`

3. Add it as a secret:
   ```bash
   gh secret set HOMEBREW_TAP_TOKEN
   ```

## License

MIT
