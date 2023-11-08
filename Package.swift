// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "AppIconSetGen",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        .executable(name: "AppIconSetGenTest", targets: ["AppIconSetGenTest"]),
        .library(name: "AppIconSetGen", targets: ["AppIconSetGen"])
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "AppIconSetGenTest",
            dependencies: ["AppIconSetGen"]),
        .target(
            name: "AppIconSetGen",
            dependencies: ["PathKit"])
    ]
)
