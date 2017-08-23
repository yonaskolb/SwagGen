class SwagGen < Formula
  desc "Swagger/OpenAPISpec code generator written in Swift"
  homepage "https://github.com/yonaskolb/SwagGen"
  url "https://github.com/yonaskolb/SwagGen/archive/0.6.0.tar.gz"
  sha256 "f84b14309807909bae1a64f026a7e6e768ca9234b7f0865f05cbbdd606f7528d"
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
