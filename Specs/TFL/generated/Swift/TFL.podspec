Pod::Spec.new do |s|
    s.name = 'TFL'
    s.authors = 'Yonas Kolb'
    s.summary = 'A generated API'
    s.version = 'v1'
    s.homepage = 'https://github.com/yonaskolb/SwagGen'
    s.source = { :git => 'git@github.com:https://github.com/yonaskolb/SwagGen.git' }
    s.ios.deployment_target = '9.0'
    s.tvos.deployment_target = '9.0'
    s.osx.deployment_target = '10.9'
    s.subspec 'TFLClient' do |cs|
      cs.source_files = 'Sources/Client/*.swift'
      cs.dependency 'TFL/TFLRequests'
      s.dependency 'Alamofire', '~> 4.9.0'
    end
    s.subspec 'TFLModels' do |cs|
      cs.source_files = 'Sources/Models/*.swift'
    end
    s.subspec 'TFLRequests' do |cs|
      cs.dependency 'TFL/TFLModels'
      cs.dependency 'TFL/TFLSharedCode'
      cs.source_files = 'Sources/Requests/*.swift'
    end
    s.subspec 'TFLSharedCode' do |cs|
      cs.source_files = 'Sources/SharedCode/*.swift'
    end
    s.source_files = 'Sources/**/*.swift'
end
