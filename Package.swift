// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "FlowSDK",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v12),
        .tvOS(.v11),
        .watchOS(.v3)
    ],
    products: [
        .library(
            name: "FlowSDK",
            targets: ["FlowSDK"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "FlowSDK",
            dependencies: []
        ),
        .testTarget(
            name: "FlowSDKTests",
            dependencies: ["FlowSDK"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
