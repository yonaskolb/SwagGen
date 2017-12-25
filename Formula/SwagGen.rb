class Swaggen < Formula
  desc "Swagger/OpenAPISpec code generator written in Swift"
  homepage "https://github.com/yonaskolb/SwagGen"
  url "https://github.com/yonaskolb/SwagGen/archive/1.1.0.tar.gz"
  sha256 "f73be1e585b1c5da6e5b93b308622cbe98ef271a94a151a5cefda095672cd7ed"
  head "https://github.com/yonaskolb/SwagGen.git"

  depends_on :xcode

  def install
    build_path = "#{buildpath}/.build/release/SwagGen"
    ohai "Building SwagGen"
    system("swift build --disable-sandbox -c release -Xswiftc -static-stdlib")
    bin.install build_path
  end
end
