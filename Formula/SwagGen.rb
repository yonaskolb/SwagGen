class Swaggen < Formula
  desc "Swagger/OpenAPISpec code generator written in Swift"
  homepage "https://github.com/yonaskolb/SwagGen"
  url "https://github.com/yonaskolb/SwagGen/archive/2.1.0.tar.gz"
  sha256 "9de0c1bb38366d806f2328d75db16aa253512bac840dda2605d36d8784bdb253"
  head "https://github.com/yonaskolb/SwagGen.git"

  depends_on :xcode

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
