// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Cafezim",
    platforms: [.macOS(.v13)],
    targets: [
        .target(
            name: "CafezimCore",
            dependencies: [],
            path: "CafezimCore/Sources",
            linkerSettings: [
                .linkedFramework("IOKit"),
            ]
        ),
        .executableTarget(
            name: "Cafezim",
            dependencies: ["CafezimCore"],
            path: "Cafezim/Sources",
            resources: [
                .process("../Resources"),
            ]
        ),
        .testTarget(
            name: "CafezimTests",
            dependencies: ["CafezimCore"],
            path: "CafezimTests"
        ),
    ]
)
