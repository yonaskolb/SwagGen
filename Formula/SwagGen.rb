class Swaggen < Formula
  desc "Swagger/OpenAPISpec code generator written in Swift"
  homepage "https://github.com/yonaskolb/SwagGen"
  url "https://github.com/yonaskolb/SwagGen/archive/1.2.0.tar.gz"
  sha256 "7d96d2781db09a58ffc9a98e70e126b612d6e34aa000675d7cd2298c1d958398"
  head "https://github.com/yonaskolb/SwagGen.git"

  depends_on :xcode

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
