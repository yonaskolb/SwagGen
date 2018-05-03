// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "TFL",
    products: [
        .library(name: "TFL", targets: ["TFL"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("4.4.0")),
        .package(url: "https://github.com/antitypical/Result.git", .exact("3.2.1")),
    ],
    targets: [
        .target(name: "TFL", dependencies: [
          "Alamofire",
          "Result",
        ], path: "Sources")
    ]
)
