Pod::Spec.new do |s|
    s.name = '{{ options.name }}'
    s.authors = '{{ options.authors|default:"Yonas Kolb" }}'
    s.summary = '{{ info.description|default:"A generated API" }}'
    s.version = '{{ info.version }}'
    s.homepage = '{{ options.homepage|default:"https://github.com/yonaskolb/SwagGen" }}'
    s.source = { :git => 'git@github.com:https://github.com/yonaskolb/SwagGen.git' }
    s.ios.deployment_target = '9.0'
    s.tvos.deployment_target = '9.0'
    s.osx.deployment_target = '10.9'
    s.subspec '{{ options.name }}Client' do |cs|
      cs.source_files = 'Sources/Client/*.swift'
      cs.dependency '{{ options.name }}/{{ options.name }}Requests'
      {% for dependency in options.dependencies %}
      s.dependency '{{ dependency.pod }}', '~> {{ dependency.version }}'
      {% endfor %}
    end
    s.subspec '{{ options.name }}Models' do |cs|
      cs.source_files = 'Sources/Models/*.swift'
    end
    s.subspec '{{ options.name }}Requests' do |cs|
      cs.dependency '{{ options.name }}/{{ options.name }}Models'
      cs.dependency '{{ options.name }}/{{ options.name }}SharedCode'
      cs.source_files = 'Sources/Requests/*.swift'
    end
    s.subspec '{{ options.name }}SharedCode' do |cs|
      cs.source_files = 'Sources/SharedCode/*.swift'
    end
    s.source_files = 'Sources/**/*.swift'
end
