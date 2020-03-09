// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Petstore",
    products: [
        .library(name: "Petstore", targets: ["PetstoreClient"]),
        .library(name: "PetstoreDynamic", type: .dynamic, targets: ["PetstoreClient"]),
        .library(name: "PetstoreRequests", targets: ["PetstoreRequests"]),
        .library(name: "PetstoreDynamicRequests", type: .dynamic, targets: ["PetstoreRequests"]),
        .library(name: "PetstoreModels", targets: ["PetstoreModels"]),
        .library(name: "PetstoreDynamicModels", type: .dynamic, targets: ["PetstoreModels"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("4.9.0")),
    ],
    targets: [
        .target(name: "PetstoreSharedCode", path: "Sources/SharedCode"),
        .target(name: "PetstoreModels", path: "Sources/Models"),
        .target(name: "PetstoreRequests", dependencies: [ "PetstoreModels", "PetstoreSharedCode"], path: "Sources/Requests"),
        .target(name: "PetstoreClient", dependencies: [
          "PetstoreRequests",
          "Alamofire",
        ], path: "Sources/Client")
    ]
)
