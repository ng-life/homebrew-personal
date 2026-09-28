class ZookeeperExplorer < Formula
  desc "Web browser for ZooKeeper nodes"
  homepage "https://github.com/ng-life/zookeeper-explorer"
  on_macos do
    on_arm do
      url "https://github.com/ng-life/zookeeper-explorer/releases/download/v0.1.2/zookeeper-explorer-macos-aarch64"
      sha256 "aaffde53f08e3b4b136a484305de8612a9808cfd587b4e34bc20d132c18c164e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/ng-life/zookeeper-explorer/releases/download/v0.1.2/zookeeper-explorer-linux-x86_64"
      sha256 "16226ef46c375532ff069002f5bbeaacbc386d0b3d6e9ce8453917fabeab26cc"
    end
  end

  def install
    config_file = etc/"zookeeper-explorer.toml"
    unless config_file.exist?
      config_file.write <<~TOML
        listen = "127.0.0.1:8080"
        allow_delete = false
        clusters = []
      TOML
      config_file.chmod 0644
    end

    binary = Dir["zookeeper-explorer-*"].first
    bin.install binary => "zookeeper-explorer"
  end

  service do
    run [opt_bin/"zookeeper-explorer", "--config", etc/"zookeeper-explorer.toml"]
    keep_alive true
    log_path var/"log/zookeeper-explorer.log"
    error_log_path var/"log/zookeeper-explorer-error.log"
  end

  def caveats
    <<~EOS
      The default configuration is #{etc}/zookeeper-explorer.toml.
      Add your ZooKeeper clusters there, then start the service with:
        brew services start #{tap}/zookeeper-explorer

      Open http://127.0.0.1:8080. To apply configuration changes:
        brew services restart #{tap}/zookeeper-explorer

      Recursive deletion is disabled by default.
    EOS
  end

  test do
    assert_path_exists bin/"zookeeper-explorer"
    assert_path_exists etc/"zookeeper-explorer.toml"
  end
end
