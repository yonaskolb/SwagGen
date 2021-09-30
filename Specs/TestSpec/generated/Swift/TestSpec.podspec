Pod::Spec.new do |s|
    s.source_files = '*.swift'
    s.name = 'TestSpec'
    s.authors = 'Yonas Kolb'
    s.summary = 'A generated API'
    s.version = '1.0'
    s.homepage = 'https://github.com/yonaskolb/SwagGen'
    s.source = { :git => 'git@github.com:https://github.com/yonaskolb/SwagGen.git' }
    s.ios.deployment_target = '10.0'
    s.tvos.deployment_target = '10.0'
    s.osx.deployment_target = '10.12'
    s.source_files = 'Sources/**/*.swift'
    s.dependency 'Alamofire', '~> 5.4.4'
end
