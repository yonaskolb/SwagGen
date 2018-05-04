// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Rocket",
    products: [
        .library(name: "Rocket", targets: ["Rocket"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("4.7.2")),
        .package(url: "https://github.com/antitypical/Result.git", .exact("4.0.0")),
    ],
    targets: [
        .target(name: "Rocket", dependencies: [
          "Alamofire",
          "Result",
        ], path: "Sources")
    ]
)
