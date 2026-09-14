class RipgrepWeb < Formula
  desc "Lightweight in-process ripgrep web log search service"
  homepage "https://github.com/ng-life/ripgrep-web"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ng-life/ripgrep-web/releases/download/v0.0.1/ripgrep-web-v0.0.1-aarch64-apple-darwin.tar.gz"
      sha256 "9634b1908856178f26efbdbdfef92e5bb610dba7e78ce6d7855834b7b9108540"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/ng-life/ripgrep-web/releases/download/v0.0.1/ripgrep-web-v0.0.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cf77958bce85d967d8b9c75d5f9476632c960bf6f1c521341eebdc0642fdf1f5"
    end
  end

  def install
    (var/"log/ripgrep-web").mkpath
    bin.install "ripgrep-web"
  end

  service do
    run [opt_bin/"ripgrep-web"]
    environment_variables(
      LOG_BASE_DIR:            var/"log/ripgrep-web",
      LISTEN_ADDR:             "127.0.0.1:5000",
      MAX_CONCURRENT_SEARCHES: "4",
      RUST_LOG:                "ripgrep_web=info,tower_http=info",
    )
    keep_alive true
    log_path var/"log/ripgrep-web.log"
    error_log_path var/"log/ripgrep-web.log"
  end

  def caveats
    <<~EOS
      The service defaults to searching #{var}/log/ripgrep-web.
      Start it with:
        brew services start #{tap}/ripgrep-web
    EOS
  end

  test do
    assert_path_exists bin/"ripgrep-web"
  end
end
