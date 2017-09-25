class Swaggen < Formula
  desc "Swagger/OpenAPISpec code generator written in Swift"
  homepage "https://github.com/yonaskolb/SwagGen"
  url "https://github.com/yonaskolb/SwagGen/archive/1.0.0.tar.gz"
  sha256 "b1534c9a490e7ab274194f7982dfd26eebb658d24da71fde4b77b93f08dbfba2"
  head "https://github.com/yonaskolb/SwagGen.git"

  depends_on :xcode

  def install
    build_path = "#{buildpath}/.build/release/SwagGen"
    ohai "Building SwagGen"
    system("swift --disable-sandbox build -c release -Xswiftc -static-stdlib")
    bin.install build_path
  end
end
