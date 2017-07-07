import PackageDescription

let package = Package(
    name: "SwagGen",
    targets: [
        Target(name: "SwagGen", dependencies: ["SwagGenKit"]),
        Target(name: "SwagGenKit"),
    ],
    dependencies: [
        .Package(url: "https://github.com/AttilaTheFun/SwaggerParser.git", majorVersion: 0),
        .Package(url: "https://github.com/kylef/PathKit.git", majorVersion: 0, minor: 8),
        .Package(url: "https://github.com/kylef/Commander.git", majorVersion: 0, minor: 6),
        .Package(url: "https://github.com/yonaskolb/Stencil.git", majorVersion: 0, minor: 9),
        .Package(url: "https://github.com/jpsim/Yams.git", majorVersion: 0, minor: 2),
        .Package(url: "https://github.com/yonaskolb/JSONUtilities.git", majorVersion: 3, minor: 3),
        .Package(url: "https://github.com/kylef/Spectre.git", majorVersion: 0, minor: 7),
        .Package(url: "https://github.com/onevcat/Rainbow", majorVersion: 2),
    ]
)
