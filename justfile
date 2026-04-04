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
