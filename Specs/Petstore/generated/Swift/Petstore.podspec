Pod::Spec.new do |s|
    s.name = 'Petstore'
    s.authors = 'Yonas Kolb'
    s.summary = 'A generated API'
    s.version = '1.0.0'
    s.homepage = 'https://github.com/yonaskolb/SwagGen'
    s.source = { :git => 'git@github.com:https://github.com/yonaskolb/SwagGen.git' }
    s.ios.deployment_target = '9.0'
    s.tvos.deployment_target = '9.0'
    s.osx.deployment_target = '10.9'
    s.subspec 'PetstoreClient' do |cs|
      cs.source_files = 'Sources/Client/*.swift'
      cs.dependency 'Petstore/PetstoreRequests'
      s.dependency 'Alamofire', '~> 4.9.0'
    end
    s.subspec 'PetstoreModels' do |cs|
      cs.source_files = 'Sources/Models/*.swift'
    end
    s.subspec 'PetstoreRequests' do |cs|
      cs.dependency 'Petstore/PetstoreModels'
      cs.dependency 'Petstore/PetstoreSharedCode'
      cs.source_files = 'Sources/Requests/*.swift'
    end
    s.subspec 'PetstoreSharedCode' do |cs|
      cs.source_files = 'Sources/SharedCode/*.swift'
    end
    s.source_files = 'Sources/**/*.swift'
end
