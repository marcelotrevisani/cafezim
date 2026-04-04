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

## Features

- Prevents your Mac from sleeping and the display from turning off
- Lives in the menu bar with a coffee cup icon (filled when active)
- Timer support: keep awake for 30min, 1h, 2h, 4h, 8h, or a custom number of hours
- Indefinite mode (default) — stays awake until you deactivate it
- Zero configuration, no Dock icon, minimal resource usage
- Uses native macOS IOKit power assertions (`IOPMAssertionCreateWithName`)

## Requirements

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
```

### Without just

```bash
# Debug build
swift build

# Release build
swift build -c release
```

The built binary will be located at:
- Debug: `.build/debug/Cafezim`
- Release: `.build/release/Cafezim`

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
```

Once running, look for the coffee cup icon (**☕**) in your menu bar.

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
│   └── Sources/
│       └── CafezimApp.swift       # App entry point, menu bar setup
├── CafezimCore/
│   └── Sources/
│       ├── SleepManager.swift     # IOKit power assertion logic
│       └── MenuBarView.swift      # SwiftUI menu bar UI
├── CafezimTests/
│   ├── SleepManagerTests.swift    # Core logic tests
│   └── MenuBarViewTests.swift     # UI model tests
└── .github/
    └── workflows/
        └── ci.yml                 # GitHub Actions CI pipeline
```

## License

MIT
