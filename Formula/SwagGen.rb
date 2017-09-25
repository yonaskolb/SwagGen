class Swaggen < Formula
  desc "Swagger/OpenAPISpec code generator written in Swift"
  homepage "https://github.com/yonaskolb/SwagGen"
  url "https://github.com/yonaskolb/SwagGen/archive/0.6.1.tar.gz"
  sha256 "5aae2001e54c9f4ec27eb9b362c2b01344c2e6d6d5ac83e2781b5551495d1b08"
  head "https://github.com/yonaskolb/SwagGen.git"

  depends_on :xcode

  def install
    build_path = "#{buildpath}/.build/release/SwagGen"
    ohai "Building SwagGen"
    system("swift --disable-sandbox build -c release -Xswiftc -static-stdlib")
    bin.install build_path
  end
end
