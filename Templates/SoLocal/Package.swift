// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "{{ options.name }}",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "{{ options.name }}", targets: ["{{ options.name }}"])
    ],
    dependencies: [
        {% for dependency in options.dependencies %}
        .package(url: "https://github.com/{{ dependency.github }}.git", .exact("{{ dependency.version }}")),
        {% endfor %}
    ],
    targets: [
        .target(name: "{{ options.name }}", dependencies: [
          {% for dependency in options.dependencies %}
          "{{ dependency.pod }}",
          {% endfor %}
        ], path: "Sources")
    ],
    swiftLanguageVersions: [.v4_2, .v5]
)
