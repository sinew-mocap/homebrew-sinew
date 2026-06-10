# typed: false
# frozen_string_literal: true

# Sinew mocap starter pack — depends on every Sinew app so one command installs
# the whole set. The metapackage itself installs only a short README.
class Sinew < Formula
  desc "Starter pack that installs every Sinew mocap app"
  homepage "https://github.com/sinew-mocap"
  url "https://github.com/sinew-mocap/driver/archive/refs/tags/v0.4.1.tar.gz"
  version "0.4.1"
  sha256 "216933b68b9f83e80bf6126048dd9f1b575d1b954dbad2400712592a2b228a4e"
  license "MIT"

  depends_on "sinew-mocap/sinew/sinew-tui"
  depends_on "sinew-mocap/sinew/sinew-viewer"
  depends_on "sinew-mocap/sinew/sinew-vr-bridge"

  def install
    (prefix/"README.md").write <<~EOS
      Sinew mocap starter pack.

      This metapackage installs every Sinew app:
        sinew-tui        rebocap dongle to /sinew OSC, with a terminal monitor
        sinew-vr-bridge  SteamVR HMD/controller poses to /vr OSC
        sinew-viewer     anny_demo, the live ANNY body viewer
    EOS
  end

  test do
    assert_path_exists prefix/"README.md"
  end
end
