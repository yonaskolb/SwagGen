// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "{{ options.name }}",
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
    ]
)
