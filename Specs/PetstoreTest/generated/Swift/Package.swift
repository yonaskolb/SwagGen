// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "PetstoreTest",
    products: [
        .library(name: "PetstoreTest", targets: ["PetstoreTest"])
    ],
    dependencies: [
        .package(url: "https://github.com/yonaskolb/JSONUtilities.git", .exact("3.3.8")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("4.4.0")),
        .package(url: "https://github.com/antitypical/Result.git", .exact("3.2.1")),
    ],
    targets: [
        .target(name: "PetstoreTest", dependencies: [
          "JSONUtilities",
          "Alamofire",
          "Result",
        ])
    ]
)
