// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Rocket",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        .library(name: "Rocket", targets: ["Rocket"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("5.4.3")),
    ],
    targets: [
        .target(name: "Rocket", dependencies: [
          "Alamofire",
        ], path: "Sources")
    ]
)
