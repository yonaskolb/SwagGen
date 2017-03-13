import PackageDescription

let package = Package(
    name: "SwagGen",
    targets: [
        Target(name: "SwagGen", dependencies: ["SwagGenKit"]),
        Target(name: "SwagGenKit", dependencies: ["Swagger"]),
    ],
    dependencies: [
        .Package(url: "https://github.com/kylef/PathKit.git", majorVersion: 0, minor: 8),
        .Package(url: "https://github.com/kylef/Commander.git", majorVersion: 0, minor: 6),
        .Package(url: "https://github.com/yonaskolb/Stencil.git", majorVersion: 0, minor: 8),
        .Package(url: "https://github.com/jpsim/Yams.git", majorVersion: 0, minor: 2),
        .Package(url: "https://github.com/lucianomarisi/JSONUtilities.git", majorVersion: 3, minor: 2),
    ]
)
