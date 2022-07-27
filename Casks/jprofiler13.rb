cask "jprofiler13" do
  version "13.0.2"
  sha256 "0a9b859afb33319035fb5039d6cc1603799a2bc23c450118a3c67703f0904a50"

  url "https://download-gcdn.ej-technologies.com/jprofiler/jprofiler_macos_#{version.dots_to_underscores}.dmg"
  name "JProfiler"
  desc "Java profiler. Licence: S-NEO_PENG#890808-g4tibemn0jen#37bb9"
  homepage "https://www.ej-technologies.com/products/jprofiler/overview.html"

  livecheck do
    url "https://www.ej-technologies.com/feeds/jprofiler/"
    regex(/JProfiler\s*Release\s*v?(\d+(?:\.\d+)+)/i)
  end

  app "JProfiler.app"
end
