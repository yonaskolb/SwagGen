// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "TestSpec",
    products: [
        .library(name: "TestSpec", targets: ["TestSpec"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("4.9.0")),
    ],
    targets: [
        .target(name: "TestSpec", dependencies: [
          "Alamofire",
        ], path: "Sources")
    ]
)
