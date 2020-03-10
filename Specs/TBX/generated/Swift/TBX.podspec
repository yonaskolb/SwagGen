Pod::Spec.new do |s|
    s.name = 'TBX'
    s.authors = 'Yonas Kolb'
    s.summary = 'A generated API'
    s.version = '2.4.1'
    s.homepage = 'https://github.com/yonaskolb/SwagGen'
    s.source = { :git => 'git@github.com:https://github.com/yonaskolb/SwagGen.git' }
    s.ios.deployment_target = '9.0'
    s.tvos.deployment_target = '9.0'
    s.osx.deployment_target = '10.9'
    s.subspec 'TBXClient' do |cs|
      cs.source_files = 'Sources/Client/*.swift'
      cs.dependency 'TBX/TBXRequests'
      s.dependency 'Alamofire', '~> 4.9.0'
    end
    s.subspec 'TBXModels' do |cs|
      cs.source_files = 'Sources/Models/*.swift'
    end
    s.subspec 'TBXRequests' do |cs|
      cs.dependency 'TBX/TBXModels'
      cs.dependency 'TBX/TBXSharedCode'
      cs.source_files = 'Sources/Requests/*.swift'
    end
    s.subspec 'TBXSharedCode' do |cs|
      cs.source_files = 'Sources/SharedCode/*.swift'
    end
    s.source_files = 'Sources/**/*.swift'
end
