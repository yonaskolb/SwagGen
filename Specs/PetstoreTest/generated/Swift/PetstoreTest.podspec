Pod::Spec.new do |s|
    s.name = 'PetstoreTest'
    s.authors = 'Yonas Kolb'
    s.summary = 'This spec is mainly for testing Petstore server and contains fake endpoints, models. Please do not use this for any other purpose.'
    s.version = '1.0.0'
    s.homepage = 'https://github.com/yonaskolb/SwagGen'
    s.source = { :git => 'git@github.com:https://github.com/yonaskolb/SwagGen.git' }
    s.ios.deployment_target = '9.0'
    s.tvos.deployment_target = '9.0'
    s.osx.deployment_target = '10.9'
    s.subspec 'PetstoreTestClient' do |cs|
      cs.source_files = 'Sources/Client/*.swift'
      cs.dependency 'PetstoreTest/PetstoreTestRequests'
      s.dependency 'Alamofire', '~> 4.9.0'
    end
    s.subspec 'PetstoreTestModels' do |cs|
      cs.source_files = 'Sources/Models/*.swift'
    end
    s.subspec 'PetstoreTestRequests' do |cs|
      cs.dependency 'PetstoreTest/PetstoreTestModels'
      cs.dependency 'PetstoreTest/PetstoreTestSharedCode'
      cs.source_files = 'Sources/Requests/*.swift'
    end
    s.subspec 'PetstoreTestSharedCode' do |cs|
      cs.source_files = 'Sources/SharedCode/*.swift'
    end
    s.source_files = 'Sources/**/*.swift'
end
