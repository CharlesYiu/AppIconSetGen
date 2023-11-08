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
    targets: [
        .target(
            name: "AppIconSetGenTest",
            dependencies: ["AppIconSetGen"]),
        .target(name: "AppIconSetGen")
    ]
)
