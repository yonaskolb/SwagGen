// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "TestSpec",
    products: [
        .library(name: "TestSpec", targets: ["TestSpecClient"]),
        .library(name: "TestSpecDynamic", type: .dynamic, targets: ["TestSpecClient"]),
        .library(name: "TestSpecRequests", targets: ["TestSpecRequests"]),
        .library(name: "TestSpecDynamicRequests", type: .dynamic, targets: ["TestSpecRequests"]),
        .library(name: "TestSpecModels", targets: ["TestSpecModels"]),
        .library(name: "TestSpecDynamicModels", type: .dynamic, targets: ["TestSpecModels"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("4.9.0")),
    ],
    targets: [
        .target(name: "TestSpecSharedCode", path: "Sources/SharedCode"),
        .target(name: "TestSpecModels", path: "Sources/Models"),
        .target(name: "TestSpecRequests", dependencies: [ "TestSpecModels", "TestSpecSharedCode"], path: "Sources/Requests"),
        .target(name: "TestSpecClient", dependencies: [
          "TestSpecRequests",
          "Alamofire",
        ], path: "Sources/Client")
    ]
)
