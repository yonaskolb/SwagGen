// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Rocket",
    products: [
        .library(name: "Rocket", targets: ["RocketClient"]),
        .library(name: "RocketDynamic", type: .dynamic, targets: ["RocketClient"]),
        .library(name: "RocketRequests", targets: ["RocketRequests"]),
        .library(name: "RocketDynamicRequests", type: .dynamic, targets: ["RocketRequests"]),
        .library(name: "RocketModels", targets: ["RocketModels"]),
        .library(name: "RocketDynamicModels", type: .dynamic, targets: ["RocketModels"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("4.9.0")),
    ],
    targets: [
        .target(name: "RocketSharedCode", path: "Sources/SharedCode"),
        .target(name: "RocketModels", path: "Sources/Models"),
        .target(name: "RocketRequests", dependencies: [ "RocketModels", "RocketSharedCode"], path: "Sources/Requests"),
        .target(name: "RocketClient", dependencies: [
          "RocketRequests",
          "Alamofire",
        ], path: "Sources/Client")
    ]
)
