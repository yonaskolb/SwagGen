// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "PetstoreTest",
    products: [
        .library(name: "PetstoreTest", targets: ["PetstoreTestClient"]),
        .library(name: "PetstoreTestDynamic", type: .dynamic, targets: ["PetstoreTestClient"]),
        .library(name: "PetstoreTestRequests", targets: ["PetstoreTestRequests"]),
        .library(name: "PetstoreTestDynamicRequests", type: .dynamic, targets: ["PetstoreTestRequests"]),
        .library(name: "PetstoreTestModels", targets: ["PetstoreTestModels"]),
        .library(name: "PetstoreTestDynamicModels", type: .dynamic, targets: ["PetstoreTestModels"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .exact("4.9.0")),
    ],
    targets: [
        .target(name: "PetstoreTestSharedCode", path: "Sources/SharedCode"),
        .target(name: "PetstoreTestModels", path: "Sources/Models"),
        .target(name: "PetstoreTestRequests", dependencies: [ "PetstoreTestModels", "PetstoreTestSharedCode"], path: "Sources/Requests"),
        .target(name: "PetstoreTestClient", dependencies: [
          "PetstoreTestRequests",
          "Alamofire",
        ], path: "Sources/Client")
    ]
)
