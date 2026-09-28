class RedisExplorer < Formula
  desc "Web browser for Redis keys and values"
  homepage "https://github.com/ng-life/redis-explorer"
  on_macos do
    on_arm do
      url "https://github.com/ng-life/redis-explorer/releases/download/v0.1.0/redis-explorer-macos-aarch64"
      sha256 "6c65f39a9f9e63493234744fc0013be9d37455b6b720bf36544010f1644789dd"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/ng-life/redis-explorer/releases/download/v0.1.0/redis-explorer-linux-x86_64"
      sha256 "a0e753a407af9fc60fc488ee774d3356f846f1222eed54c0f1c35c310b0e08e8"
    end
  end

  def install
    config_file = etc/"redis-explorer.toml"
    unless config_file.exist?
      config_file.write <<~TOML
        listen = "127.0.0.1:8080"
        allow_delete = false
        page_size = 100
        instances = []
      TOML
      config_file.chmod 0644
    end

    binary = Dir["redis-explorer-*"].first
    bin.install binary => "redis-explorer"
  end

  service do
    run [opt_bin/"redis-explorer", "--config", etc/"redis-explorer.toml"]
    keep_alive true
    log_path var/"log/redis-explorer.log"
    error_log_path var/"log/redis-explorer-error.log"
  end

  def caveats
    <<~EOS
      The default configuration is #{etc}/redis-explorer.toml.
      Add Redis instances there, then start the service with:
        brew services start #{tap}/redis-explorer

      Open http://127.0.0.1:8080. To apply configuration changes:
        brew services restart #{tap}/redis-explorer

      Key deletion is disabled by default.
    EOS
  end

  test do
    assert_match "Redis", shell_output("#{bin}/redis-explorer --help")
    assert_path_exists etc/"redis-explorer.toml"
  end
end
