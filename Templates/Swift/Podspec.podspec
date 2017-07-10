Pod::Spec.new do |s|
    s.source_files = '*.swift'
    s.name = '{{ options.name }}'
    s.authors = '{{ options.authors|default:"Yonas Kolb" }}'
    s.summary = '{{ info.description|default:"A generated API" }}'
    s.version = '{{ info.version }}'
    s.homepage = '{{ options.homepage|default:"https://github.com/yonaskolb/SwagGen" }}'
    s.source = { :git => 'git@github.com:https://github.com/yonaskolb/SwagGen.git' }
    s.ios.deployment_target = '9.0'
    s.tvos.deployment_target = '9.0'
    s.osx.deployment_target = '10.9'
    s.source_files = 'Sources/**/*.swift'
    {% for dependency in options.dependencies %}
    s.dependency '{{ dependency.pod }}', '~> {{ dependency.version }}'
    {% endfor %}
end
