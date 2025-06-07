// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FitJourney",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Authentication",
            targets: ["Authentication"]),
        .library(
            name: "FitnessTracker",
            targets: ["FitnessTracker"]),
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
            name: "FitnessTracker",
            dependencies: [],
            path: "Sources/FitnessTracker",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]),
        .target(
            name: "Networking",
            dependencies: [],
            path: "Sources/Networking",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]),
        // Test targets
        .testTarget(
            name: "AuthenticationTests",
            dependencies: ["Authentication"],
            path: "Tests/AuthenticationTests")
    ]
)
