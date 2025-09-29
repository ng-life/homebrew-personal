class ShadowsocksServer < Formula
  desc "Meta formula for launching shadowsocks-rust's ssserver as a service"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"

  url "https://github.com/shadowsocks/shadowsocks-rust/archive/refs/tags/v1.23.5.tar.gz"
  sha256 "edeef2408ae54108fa176b4e59cb04b4ef4dbe62da96d2459d9821b238ad94e8"
  license "MIT"
  head "https://github.com/shadowsocks/shadowsocks-rust.git", branch: "master"
  
  version "1.0.0"
  depends_on "shadowsocks-rust"

  def install
    # 空安装，仅用于依赖 shadowsocks-rust
  end

  service do
    run [Formula["shadowsocks-rust"].opt_bin/"ssserver", "-c", etc/"shadowsocks-server.json"]
    keep_alive true
    working_dir var
    log_path var/"log/shadowsocks-server.log"
    error_log_path var/"log/shadowsocks-server-error.log"
  end

  def caveats
    <<~EOS
      This formula is a meta launcher for shadowsocks-rust's ssserver.
      Please create your configuration at:
        #{etc}/shadowsocks-server.json

      Example config:
      {
        "server": "0.0.0.0",
        "server_port": 8388,
        "password": "your_password",
        "method": "aes-256-gcm"
      }
    EOS
  end
end
