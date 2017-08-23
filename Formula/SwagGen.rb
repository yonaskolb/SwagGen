class Swaggen < Formula
  desc "Swagger/OpenAPISpec code generator written in Swift"
  homepage "https://github.com/yonaskolb/SwagGen"
  url "https://github.com/yonaskolb/SwagGen/archive/0.6.0.tar.gz"
  sha256 "fe93004b4516d5bb3cefe7177a547ce971eb013aa17f8b5471772a243c46ff66"
  head "https://github.com/yonaskolb/SwagGen.git"

  depends_on :xcode

  def install
    yaml_lib_path = "#{buildpath}/.build/release/libCYaml.dylib"
    build_path = "#{buildpath}/.build/release/SwagGen"
    ohai "Building SwagGen"
    system("swift build -c release -Xlinker -rpath -Xlinker @executable_path -Xswiftc -static-stdlib")
    system("install_name_tool -change #{yaml_lib_path} #{frameworks}/libCYaml.dylib #{build_path}")
    frameworks.install yaml_lib_path
    bin.install build_path
  end
end
