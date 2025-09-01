class Services < Formula
  desc "Personal Services Manager"
  homepage "https://github.com/ng-life"
  license "MIT"

  depends_on "shadowsocks-rust"

  service do
    run [opt_bin/"ssserver", "-c", etc/"shadowsocks-rust.json"]
    keep_alive true
  end

end
