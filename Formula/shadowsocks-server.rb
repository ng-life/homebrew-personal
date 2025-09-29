class ShadowsocksServer < Formula
  desc "Meta formula for launching shadowsocks-rust's ssserver as a service"
  homepage "https://github.com/shadowsocks/shadowsocks-rust"

  url "https://www.google.com/generate_204"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  license "MIT"
  
  version "1.1.1"
  depends_on "shadowsocks-rust"

  def install
    # 占位文件，避免 empty installation 错误
    (prefix/"README.shadowsocks-server").write <<~EOS
      This is a meta formula. It depends on shadowsocks-rust and provides a service for ssserver.
      No files are installed.
    EOS
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
