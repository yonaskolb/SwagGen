Pod::Spec.new do |s|
    s.source_files = '*.swift'
    s.name = 'Rocket'
    s.authors = 'Yonas Kolb'
    s.summary = 'An Orchestration Layer that takes ISL services and packages them in a more targeted way for front-end applications.
This in turn makes client integration easier and reduces the complexity and size of front-end applications.
Rocket is also customisable - allowing UI engineers to ‘remix’ the existing back-end services into something that
best suits the application they are developing.
'
    s.version = '1.0.0'
    s.homepage = 'https://github.com/yonaskolb/SwagGen'
    s.source = { :git => 'git@github.com:https://github.com/yonaskolb/SwagGen.git' }
    s.ios.deployment_target = '9.0'
    s.tvos.deployment_target = '9.0'
    s.osx.deployment_target = '10.9'
    s.source_files = 'Sources/**/*.swift'
    s.dependency 'Alamofire', '~> 4.9.0'
end
