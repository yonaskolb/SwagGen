// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Petstore",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        .library(name: "Petstore", targets: ["Petstore"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("5.4.3")),
    ],
    targets: [
        .target(name: "Petstore", dependencies: [
          "Alamofire",
        ], path: "Sources")
    ]
)
