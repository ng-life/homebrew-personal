class RipgrepWeb < Formula
  desc "Lightweight in-process ripgrep web log search service"
  homepage "https://github.com/ng-life/ripgrep-web"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ng-life/ripgrep-web/releases/download/v0.0.2/ripgrep-web-v0.0.2-aarch64-apple-darwin.tar.gz"
      sha256 "df0275b9d49f1e113cb1b988dffc954ea7c89f0509c8d49f195bfcf9aa79010e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/ng-life/ripgrep-web/releases/download/v0.0.2/ripgrep-web-v0.0.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "de49bc2d940517bfc6a0e47c3f0afc28fcb4f2a26484e0bf7b5b1d93081799ee"
    end
  end

  def install
    config_file = etc/"ripgrep-web.json"
    unless config_file.exist?
      config_file.write <<~JSON
        {
          "base_dir": "#{var}/log/ripgrep-web",
          "listen_addr": "127.0.0.1:5000",
          "max_concurrent_searches": 4,
          "rust_log": "ripgrep_web=info,tower_http=info"
        }
      JSON
      config_file.chmod 0644
    end

    (var/"log/ripgrep-web").mkpath
    bin.install "ripgrep-web"
  end

  service do
    run [opt_bin/"ripgrep-web", "--config", etc/"ripgrep-web.json"]
    keep_alive true
    log_path var/"log/ripgrep-web.log"
    error_log_path var/"log/ripgrep-web.log"
  end

  def caveats
    <<~EOS
      The default configuration is #{etc}/ripgrep-web.json.
      Edit it, then restart the service.
      Start it with:
        brew services start #{tap}/ripgrep-web
    EOS
  end

  test do
    assert_path_exists bin/"ripgrep-web"
    assert_path_exists etc/"ripgrep-web.json"
  end
end
