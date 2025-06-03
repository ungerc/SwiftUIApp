// swift-tools-version: 6.1
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
            path: "Sources/Networking",
            exclude: []),
        .target(
            name: "Authentication",
            dependencies: ["Networking"],
            path: "Sources/Authentication",
            exclude: []),
        .target(
            name: "FitnessTracker",
            dependencies: ["Networking", "Authentication"],
            path: "Sources/FitnessTracker",
            exclude: []),
        .target(
            name: "AppCore",
            dependencies: ["Networking", "Authentication", "FitnessTracker"],
            path: "Sources/AppCore",
            exclude: []),
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
