// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FitJourney",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Networking",
            targets: ["Networking"]),
        .library(
            name: "Authentication",
            targets: ["Authentication"]),
        .library(
            name: "FitnessTracker",
            targets: ["FitnessTracker"]),
        .library(
            name: "AppCore",
            type: .dynamic,
            targets: ["AppCore"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Networking",
            dependencies: [],
            path: "Sources/Networking",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]),
        .target(
            name: "Authentication",
            dependencies: ["Networking"],
            path: "Sources/Authentication",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]),
        .target(
            name: "FitnessTracker",
            dependencies: ["Networking", "Authentication"],
            path: "Sources/FitnessTracker",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]),
        .target(
            name: "AppCore",
            dependencies: ["Networking", "Authentication", "FitnessTracker"],
            path: "Sources/AppCore",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"]),
        .testTarget(
            name: "AuthenticationTests",
            dependencies: ["Authentication"]),
        .testTarget(
            name: "FitnessTrackerTests",
            dependencies: ["FitnessTracker"]),
        .testTarget(
            name: "AppCoreTests",
            dependencies: ["AppCore"])
    ]
)
