class RedisExplorer < Formula
  desc "Web browser for Redis keys and values"
  homepage "https://github.com/ng-life/redis-explorer"
  on_macos do
    on_arm do
      url "https://github.com/ng-life/redis-explorer/releases/download/v0.1.1/redis-explorer-macos-aarch64"
      sha256 "4b0cdcc5c0f82090347d72f411a47f98b91b11172a3751a540a93d951d38a552"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/ng-life/redis-explorer/releases/download/v0.1.1/redis-explorer-linux-x86_64"
      sha256 "c5c018b3af9707b940ac5fb0a74dae956e2aa98a39bd618b7691086d9ba32d58"
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
