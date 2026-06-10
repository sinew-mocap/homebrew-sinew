# typed: false
# frozen_string_literal: true

# Sinew ANNY body viewer — a polyscope GUI driven by /sinew and /vr OSC.
# Ships the prebuilt macOS (arm64) anny_demo binary from the release.
class SinewViewer < Formula
  desc "Live ANNY body viewer driven by /sinew and /vr OSC"
  homepage "https://github.com/sinew-mocap/viewer"
  url "https://github.com/sinew-mocap/viewer/releases/download/v0.4.1/sinew-viewer-macos.zip"
  version "0.4.1"
  sha256 "5deb6980220172a20af3b4ceebfc67e15ee872c41deddb0c29d78d1febc890d4"
  license "MIT"

  def install
    # anny_demo resolves lbs.spv and the soma_pheno.bin phenotype model next to its
    # own executable, so install them alongside it (this is what renders the body).
    bin.install "anny_demo", "lbs.spv", "soma_pheno.bin"
  end

  test do
    # anny_demo opens a polyscope window and binds OSC sockets, so a headless test
    # cannot run it; confirm the binary installs and is runnable.
    assert_predicate bin/"anny_demo", :executable?
  end
end
