Pod::Spec.new do |s|
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
    s.subspec 'RocketClient' do |cs|
      cs.source_files = 'Sources/Client/*.swift'
      cs.dependency 'Rocket/RocketRequests'
      s.dependency 'Alamofire', '~> 4.9.0'
    end
    s.subspec 'RocketModels' do |cs|
      cs.source_files = 'Sources/Models/*.swift'
    end
    s.subspec 'RocketRequests' do |cs|
      cs.dependency 'Rocket/RocketModels'
      cs.dependency 'Rocket/RocketSharedCode'
      cs.source_files = 'Sources/Requests/*.swift'
    end
    s.subspec 'RocketSharedCode' do |cs|
      cs.source_files = 'Sources/SharedCode/*.swift'
    end
    s.source_files = 'Sources/**/*.swift'
end
