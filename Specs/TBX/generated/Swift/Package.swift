// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "TBX",
    products: [
        .library(name: "TBX", targets: ["TBXClient"]),
        .library(name: "TBXDynamic", type: .dynamic, targets: ["TBXClient"]),
        .library(name: "TBXRequests", targets: ["TBXRequests"]),
        .library(name: "TBXDynamicRequests", type: .dynamic, targets: ["TBXRequests"]),
        .library(name: "TBXModels", targets: ["TBXModels"]),
        .library(name: "TBXDynamicModels", type: .dynamic, targets: ["TBXModels"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("4.9.0")),
    ],
    targets: [
        .target(name: "TBXSharedCode", path: "Sources/SharedCode"),
        .target(name: "TBXModels", path: "Sources/Models"),
        .target(name: "TBXRequests", dependencies: [ "TBXModels", "TBXSharedCode"], path: "Sources/Requests"),
        .target(name: "TBXClient", dependencies: [
          "TBXRequests",
          "Alamofire",
        ], path: "Sources/Client")
    ]
)
