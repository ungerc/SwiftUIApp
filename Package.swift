// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Authentication",
            targets: ["Authentication"]),
        .library(
            name: "Benefit",
            targets: ["Benefit"]),
        .library(
            name: "Networking",
            targets: ["Networking"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Authentication",
            dependencies: [],
            path: "Sources/Authentication",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]),
        .target(
            name: "Benefit",
            dependencies: [],
            path: "Sources/Benefit",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]),
        .target(
            name: "Networking",
            dependencies: [],
            path: "Sources/Networking",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]),
    ]
)
