// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "alter-core",
    platforms: [
            .iOS(.v13)
//          .macOS(.v10_14), 
    ],
    products: [
        .library(
            name: "alter-core",
            targets: ["alter-core"]),
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(
                    name: "alter-core",
                    path: "frameworks/AlterCore.xcframework"
                )
    ]
)
