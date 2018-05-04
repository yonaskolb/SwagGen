class Swaggen < Formula
  desc "Swagger/OpenAPISpec code generator written in Swift"
  homepage "https://github.com/yonaskolb/SwagGen"
  url "https://github.com/yonaskolb/SwagGen/archive/2.0.0.tar.gz"
  sha256 "ff307102cbb8e864b6c0d2c5b7bc7f4ba2859919d472b70c6117f4552836aebe"
  head "https://github.com/yonaskolb/SwagGen.git"

  depends_on :xcode

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
