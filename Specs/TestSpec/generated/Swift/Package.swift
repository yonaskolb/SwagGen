// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "TestSpec",
    products: [
        .library(name: "TestSpec", targets: ["TestSpec"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("4.8.1")),
        .package(url: "https://github.com/antitypical/Result.git", .exact("4.1.0")),
    ],
    targets: [
        .target(name: "TestSpec", dependencies: [
          "Alamofire",
          "Result",
        ], path: "Sources")
    ]
)
