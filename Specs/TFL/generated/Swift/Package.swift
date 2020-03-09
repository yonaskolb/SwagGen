// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "TFL",
    products: [
        .library(name: "TFL", targets: ["TFLClient"]),
        .library(name: "TFLDynamic", type: .dynamic, targets: ["TFLClient"]),
        .library(name: "TFLRequests", targets: ["TFLRequests"]),
        .library(name: "TFLDynamicRequests", type: .dynamic, targets: ["TFLRequests"]),
        .library(name: "TFLModels", targets: ["TFLModels"]),
        .library(name: "TFLDynamicModels", type: .dynamic, targets: ["TFLModels"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("4.9.0")),
    ],
    targets: [
        .target(name: "TFLSharedCode", path: "Sources/SharedCode"),
        .target(name: "TFLModels", path: "Sources/Models"),
        .target(name: "TFLRequests", dependencies: [ "TFLModels", "TFLSharedCode"], path: "Sources/Requests"),
        .target(name: "TFLClient", dependencies: [
          "TFLRequests",
          "Alamofire",
        ], path: "Sources/Client")
    ]
)
