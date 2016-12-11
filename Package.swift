import PackageDescription

let package = Package(
    name: "SwagGen",
    dependencies: [
        .Package(url: "https://github.com/kylef/PathKit.git", Version(0,7,0)),
        .Package(url: "https://github.com/kylef/Commander.git", Version(0,6,0)),
        .Package(url: "https://github.com/kylef/Stencil.git", Version(0,7,2)),
        .Package(url: "https://github.com/behrang/YamlSwift.git", Version(3,3,1)),
        .Package(url: "https://github.com/lucianomarisi/JSONUtilities.git", Version(3,1,0)),
    ]
)
