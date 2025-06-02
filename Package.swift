// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "FitJourney",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "Networking", targets: ["Networking"]),
        .library(name: "Authentication", targets: ["Authentication"]),
        .library(name: "FitnessTracker", targets: ["FitnessTracker"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Networking",
            dependencies: []),
        .target(
            name: "Authentication",
            dependencies: ["Networking"]),
        .target(
            name: "FitnessTracker",
            dependencies: ["Networking", "Authentication"]),
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
