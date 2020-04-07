// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "SwagGen",
    products: [
        .executable(name: "swaggen", targets: ["SwagGen"]),
        .library(name: "SwagGenKit", targets: ["SwagGenKit"]),
        .library(name: "Swagger", targets: ["Swagger"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit.git", from: "0.9.0"),
        .package(url: "https://github.com/jakeheis/SwiftCLI", from: "6.0.1"),
        .package(url: "https://github.com/stencilproject/Stencil.git", from: "0.13.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "2.0.0"),
        .package(url: "https://github.com/yonaskolb/JSONUtilities.git", from: "4.2.0"),
        .package(url: "https://github.com/kylef/Spectre.git", from: "0.9.0"),
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "SwagGen", dependencies: [
          "SwagGenKit",
          "SwiftCLI",
          "Rainbow",
          "PathKit",
        ]),
        .target(name: "SwagGenKit", dependencies: [
          "Swagger",
          "JSONUtilities",
          "PathKit",
          "Stencil",
        ]),
        .target(name: "Swagger", dependencies: [
          "JSONUtilities",
          "Yams",
          "PathKit",
        ]),
        .testTarget(name: "SwagGenKitTests", dependencies: [
          "SwagGenKit",
        ]),
        .testTarget(name: "SwaggerTests", dependencies: [
          "Swagger",
          "Spectre",
        ]),
    ]
)
