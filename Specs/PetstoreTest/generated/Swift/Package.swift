// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "PetstoreTest",
    products: [
        .library(name: "PetstoreTest", targets: ["PetstoreTest"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("4.8.2")),
        .package(url: "https://github.com/antitypical/Result.git", .exact("4.1.0")),
    ],
    targets: [
        .target(name: "PetstoreTest", dependencies: [
          "Alamofire",
          "Result",
        ], path: "Sources")
    ]
)
