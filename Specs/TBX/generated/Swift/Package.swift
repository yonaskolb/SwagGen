// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "TBX",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        .library(name: "TBX", targets: ["TBX"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("5.4.4")),
    ],
    targets: [
        .target(name: "TBX", dependencies: [
          "Alamofire",
        ], path: "Sources")
    ]
)
