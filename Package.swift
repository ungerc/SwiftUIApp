// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "FitJourney",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "AppCore",
            type: .dynamic,
            targets: ["AppCore"]),
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
            name: "AppCore",
            dependencies: ["Networking", "Authentication", "FitnessTracker"],
            path: "Sources/AppCore",
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
            name: "Networking",
            dependencies: [],
            path: "Sources/Networking",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")])
        //        .testTarget(
        //            name: "NetworkingTests",
        //            dependencies: ["Networking"]),
        //        .testTarget(
        //            name: "AuthenticationTests",
        //            dependencies: ["Authentication"]),
        //        .testTarget(
        //            name: "FitnessTrackerTests",
        //            dependencies: ["FitnessTracker"]),
        //        .testTarget(
        //            name: "AppCoreTests",
        //            dependencies: ["AppCore"])
    ]
)
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftUIApp",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Authentication",
            targets: ["Authentication"]),
        .library(
            name: "AppCore",
            targets: ["AppCore"]),
        .library(
            name: "Networking",
            targets: ["Networking"]),
        .library(
            name: "FitnessTracker",
            targets: ["FitnessTracker"])
    ],
    dependencies: [],
    targets: [
        // Main targets
        .target(
            name: "Authentication",
            dependencies: [],
            path: "Sources/Authentication"),
        .target(
            name: "AppCore",
            dependencies: ["Authentication", "Networking", "FitnessTracker"],
            path: "Sources/AppCore"),
        .target(
            name: "Networking",
            dependencies: [],
            path: "Sources/Networking"),
        .target(
            name: "FitnessTracker",
            dependencies: [],
            path: "Sources/FitnessTracker"),
        
        // Test targets
        .testTarget(
            name: "AuthenticationTests",
            dependencies: ["Authentication"],
            path: "Tests/AuthenticationTests"),
        .testTarget(
            name: "AppCoreTests",
            dependencies: ["AppCore", "Authentication", "FitnessTracker"],
            path: "Tests/AppCoreTests")
    ]
)
