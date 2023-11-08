// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "AppIconSetGen",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        .library(name: "AppIconSetGen", targets: ["AppIconSetGen"])
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "AppIconSetGen",
            dependencies: ["PathKit"])
    ]
)
