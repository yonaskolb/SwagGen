// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "AppStoreConnect",
    products: [
        .library(name: "AppStoreConnect", targets: ["AppStoreConnect"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("4.9.0")),
    ],
    targets: [
        .target(name: "AppStoreConnect", dependencies: [
          "Alamofire",
        ], path: "Sources")
    ]
)
