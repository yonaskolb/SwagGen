Pod::Spec.new do |s|
    s.source_files = '*.swift'
    s.name = 'StargateKitRequest'
    s.authors = 'jmacko@pagesjaunes.fr'
    s.summary = 'Orchestrateur Stargate : back office mobile'
    s.version = '{{ info.version }}'
    s.swift_versions = ['5.0', '4.2']
    s.homepage = 'https://github.com/PagesjaunesMobile/iOS-StargateKitRequest'
    s.source = { :git => 'git@github.com:PagesjaunesMobile/iOS-StargateKitRequest.git', :tag => s.version.to_s  }
    s.ios.deployment_target = '11.0'
    s.source_files = 'Sources/**/*.swift'
    s.frameworks = 'Foundation'
    s.pod_target_xcconfig = { 'SWIFT_OPTIMIZATION_LEVEL' => '-Osize' }
    {% for dependency in options.dependencies %}
    s.dependency '{{ dependency.pod }}', '~> {{ dependency.version }}'
    {% endfor %}
end
