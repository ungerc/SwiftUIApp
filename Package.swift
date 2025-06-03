// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FitJourney",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "Networking", targets: ["Networking"]),
        .library(name: "Authentication", targets: ["Authentication"]),
        .library(name: "FitnessTracker", targets: ["FitnessTracker"]),
        .library(name: "AppCore", targets: ["AppCore"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Networking",
            dependencies: [],
            path: "Sources/Networking"),
        .target(
            name: "Authentication",
            dependencies: ["Networking"],
            path: "Sources/Authentication"),
        .target(
            name: "FitnessTracker",
            dependencies: ["Networking", "Authentication"],
            path: "Sources/FitnessTracker"),
        .target(
            name: "AppCore",
            dependencies: ["Networking", "Authentication", "FitnessTracker"],
            path: "Sources/AppCore"),
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
