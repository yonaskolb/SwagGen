// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "TVDB",
    products: [
        .library(name: "TVDB", targets: ["TVDB"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("4.9.0")),
    ],
    targets: [
        .target(name: "TVDB", dependencies: [
          "Alamofire",
        ], path: "Sources")
    ]
)
