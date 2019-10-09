// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Petstore",
    products: [
        .library(name: "Petstore", targets: ["Petstore"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("4.9.0")),
    ],
    targets: [
        .target(name: "Petstore", dependencies: [
          "Alamofire",
        ], path: "Sources")
    ]
)
