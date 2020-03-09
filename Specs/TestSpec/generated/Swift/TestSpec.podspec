Pod::Spec.new do |s|
    s.name = 'TestSpec'
    s.authors = 'Yonas Kolb'
    s.summary = 'A generated API'
    s.version = '1.0'
    s.homepage = 'https://github.com/yonaskolb/SwagGen'
    s.source = { :git => 'git@github.com:https://github.com/yonaskolb/SwagGen.git' }
    s.ios.deployment_target = '9.0'
    s.tvos.deployment_target = '9.0'
    s.osx.deployment_target = '10.9'
    s.subspec 'TestSpecClient' do |cs|
      cs.source_files = 'Sources/Client/*.swift'
      cs.dependency 'TestSpec/TestSpecRequests'
      s.dependency 'Alamofire', '~> 4.9.0'
    end
    s.subspec 'TestSpecModels' do |cs|
      cs.source_files = 'Sources/Models/*.swift'
    end
    s.subspec 'TestSpecRequests' do |cs|
      cs.dependency 'TestSpec/TestSpecModels'
      cs.dependency 'TestSpec/TestSpecSharedCode'
      cs.source_files = 'Sources/Requests/*.swift'
    end
    s.subspec 'TestSpecSharedCode' do |cs|
      cs.source_files = 'Sources/SharedCode/*.swift'
    end
    s.source_files = 'Sources/**/*.swift'
end
