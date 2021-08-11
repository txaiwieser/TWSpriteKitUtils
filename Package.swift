// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "TWSpriteKitUtils",
    platforms: [
        .iOS(.v12),
        .macOS(.v11),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "TWSpriteKitUtils",
            targets: ["TWSpriteKitUtils"]
        ),
    ],
    targets: [
        .target(
            name: "TWSpriteKitUtils",
            dependencies: []
        ),
        .testTarget(
            name: "TWSpriteKitUtilsTests",
            dependencies: ["TWSpriteKitUtils"]
        ),
    ]
)
