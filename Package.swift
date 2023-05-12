// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LinkPreview",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "LinkPreview",
            targets: ["LinkPreview"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/hyperoslo/Cache", from: "6.0.0"),
    ],
    targets: [
        .target(
            name: "LinkPreview",
            dependencies: ["Cache"]
        ),
        .testTarget(
            name: "LinkPreviewTests",
            dependencies: ["LinkPreview"]
        ),
    ]
)
