import PackageDescription

let package = Package(
    name: "API",
    dependencies: [
        .Package(url: "https://github.com/lucianomarisi/JSONUtilities.git", "3.2.0"),
        .Package(url: "https://github.com/Alamofire/Alamofire.git", "4.4.0"),
        .Package(url: "https://github.com/antitypical/Result.git", "3.2.1"),
    ]
)
