// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "FitJourney",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "Networking", path: "Sources/Networking", targets: ["Networking"]),
        .library(name: "Authentication", path: "Sources/Authentication" targets: ["Authentication"]),
        .library(name: "FitnessTracker", path: "Sources/FitnessTracker", targets: ["FitnessTracker"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Networking",
            dependencies: []),
        .target(
            name: "Authentication",
            dependencies: []),
        .target(
            name: "FitnessTracker",
            dependencies: []),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"]),
        .testTarget(
            name: "AuthenticationTests",
            dependencies: ["Authentication"]),
        .testTarget(
            name: "FitnessTrackerTests",
            dependencies: ["FitnessTracker"])
    ]
)
