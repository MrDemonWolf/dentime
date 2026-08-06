// swift-tools-version:5.10
import PackageDescription

// Platforms for iOS and watchOS are declared now even though only macOS ships first,
// so the package stays portable when those targets land. See docs/planning/DECISIONS.md.
let package = Package(
    name: "DenTimeCore",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .watchOS(.v10),
    ],
    products: [
        .library(name: "DenTimeCore", targets: ["DenTimeCore"]),
    ],
    targets: [
        .target(name: "DenTimeCore"),
        .testTarget(name: "DenTimeCoreTests", dependencies: ["DenTimeCore"]),
    ]
)
