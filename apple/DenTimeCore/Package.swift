// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DenTimeCore",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(name: "DenTimeCore", targets: ["DenTimeCore"]),
    ],
    targets: [
        .target(
            name: "DenTimeCore",
            path: "Sources/DenTimeCore"
        ),
        .testTarget(
            name: "DenTimeCoreTests",
            dependencies: ["DenTimeCore"],
            path: "Tests/DenTimeCoreTests"
        ),
    ]
)
