// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Rocket",
    products: [
        .library(name: "Rocket", targets: ["Rocket"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("4.9.0")),
    ],
    targets: [
        .target(name: "Rocket", dependencies: [
          "Alamofire",
        ], path: "Sources")
    ]
)
