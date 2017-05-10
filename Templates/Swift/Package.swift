import PackageDescription

let package = Package(
    name: "{{ options.name }}",
    dependencies: [
        {% for dependency in options.dependencies %}
        .Package(url: "https://github.com/{{ dependency.github }}.git", "{{ dependency.version }}"),
        {% endfor %}
    ]
)
