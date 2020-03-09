// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "{{ options.name }}",
    products: [
        .library(name: "{{ options.name }}", targets: ["{{ options.name }}Client"]),
        .library(name: "{{ options.name }}Dynamic", type: .dynamic, targets: ["{{ options.name }}Client"]),
        .library(name: "{{ options.name }}Requests", targets: ["{{ options.name }}Requests"]),
        .library(name: "{{ options.name }}DynamicRequests", type: .dynamic, targets: ["{{ options.name }}Requests"]),
        .library(name: "{{ options.name }}Models", targets: ["{{ options.name }}Models"]),
        .library(name: "{{ options.name }}DynamicModels", type: .dynamic, targets: ["{{ options.name }}Models"]),
    ],
    dependencies: [
        {% for dependency in options.dependencies %}
        .package(url: "https://github.com/{{ dependency.github }}.git", .exact("{{ dependency.version }}")),
        {% endfor %}
    ],
    targets: [
        .target(name: "{{ options.name }}SharedCode", path: "Sources/SharedCode"),
        .target(name: "{{ options.name }}Models", path: "Sources/Models"),
        .target(name: "{{ options.name }}Requests", dependencies: [ "{{ options.name }}Models", "{{ options.name }}SharedCode"], path: "Sources/Requests"),
        .target(name: "{{ options.name }}Client", dependencies: [
          "{{ options.name }}Requests",
          {% for dependency in options.dependencies %}
          "{{ dependency.pod }}",
          {% endfor %}
        ], path: "Sources/Client")
    ]
)
