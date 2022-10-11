// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "FlowSDK",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "FlowSDK",
            targets: ["FlowSDK"])
    ],
    dependencies: [
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.8.2"),
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.2.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.5.1")),
        .package(url: "https://github.com/GigaBitcoin/secp256k1.swift.git", from: "0.9.2")
    ],
    targets: [
        .target(
            name: "Cadence",
            dependencies: [
                "BigInt",
                "CryptoSwift"
            ]
        ),
        .target(
            name: "FlowSDK",
            dependencies: [
                "BigInt",
                "CryptoSwift",
                "Cadence",
                .product(name: "GRPC", package: "grpc-swift"),
                .product(name: "secp256k1", package: "secp256k1.swift")
            ]
        ),
        .testTarget(
            name: "CadenceTests",
            dependencies: ["Cadence"]
        ),
        .testTarget(
            name: "FlowSDKTests",
            dependencies: ["FlowSDK"],
            resources: [
                .copy("TestData")
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
