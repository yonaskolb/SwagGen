// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Petstore",
    products: [
        .library(name: "Petstore", targets: ["Petstore"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("4.8.2")),
        .package(url: "https://github.com/antitypical/Result.git", .exact("4.1.0")),
    ],
    targets: [
        .target(name: "Petstore", dependencies: [
          "Alamofire",
          "Result",
        ], path: "Sources")
    ]
)
