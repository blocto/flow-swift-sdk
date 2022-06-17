// swift-tools-version:5.3

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
            targets: ["SDK"])
    ],
    dependencies: [
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.0.0"),
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.2.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.5.1")),
        .package(url: "https://github.com/portto/secp256k1.swift", from: "0.7.1")
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
            name: "Crypto",
            dependencies: [
                "CryptoSwift",
                .product(name: "secp256k1Swift", package: "secp256k1.swift")
            ]
        ),
        .target(
            name: "Protobuf",
            dependencies: [
                .product(name: "GRPC", package: "grpc-swift")
            ]
        ),
        .target(
            name: "SDK",
            dependencies: [
                "BigInt",
                "CryptoSwift",
                "Protobuf",
                "Cadence",
                "Crypto"
            ]
        ),
        .testTarget(
            name: "CadenceTests",
            dependencies: ["Cadence"]
        ),
        .testTarget(
            name: "CryptoTests",
            dependencies: ["Crypto"]
        ),
        .testTarget(
            name: "SDKTests",
            dependencies: ["SDK"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
