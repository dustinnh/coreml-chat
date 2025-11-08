// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreChat",
    platforms: [
        .iOS(.v18)
    ],
    dependencies: [
        // Swift Transformers for tokenization
        .package(url: "https://github.com/huggingface/swift-transformers", from: "0.1.17")
    ],
    targets: [
        .target(
            name: "CoreChat",
            dependencies: [
                .product(name: "Transformers", package: "swift-transformers")
            ]
        )
    ]
)
