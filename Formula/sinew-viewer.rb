# typed: false
# frozen_string_literal: true

# Sinew ANNY body viewer — a polyscope GUI driven by /sinew and /vr OSC.
# Ships the prebuilt macOS (arm64) anny_demo binary from the release.
class SinewViewer < Formula
  desc "Live ANNY body viewer driven by /sinew and /vr OSC"
  homepage "https://github.com/sinew-mocap/viewer"
  url "https://github.com/sinew-mocap/viewer/releases/download/v0.4.0/sinew-viewer-macos.zip"
  version "0.4.0"
  sha256 "f9d5a03feafb19590f3598b6c6a1505a2d6c658315e9e51b524c8b3a60dfe909"
  license "MIT"

  def install
    bin.install "anny_demo"
    pkgshare.install "lbs.spv"
  end

  test do
    # anny_demo opens a polyscope window and binds OSC sockets, so a headless test
    # cannot run it; confirm the binary installs and is runnable.
    assert_predicate bin/"anny_demo", :executable?
  end
end
