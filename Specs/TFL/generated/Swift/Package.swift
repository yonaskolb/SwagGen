// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "TFL",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        .library(name: "TFL", targets: ["TFL"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("5.4.3")),
    ],
    targets: [
        .target(name: "TFL", dependencies: [
          "Alamofire",
        ], path: "Sources")
    ]
)
