# typed: false
# frozen_string_literal: true

# osctest — a minimal Lean OSC sender for poking the /sinew stream.  Ships the
# prebuilt release binary (Linux x86_64, macOS arm64).
class SinewOsctest < Formula
  desc "Minimal Lean OSC sender for testing the /sinew stream"
  homepage "https://github.com/sinew-mocap/osc-tester"
  version "0.1.0"
  license "MIT"

  # Single-file prebuilt binary per platform.  url/sha256 can't live in on_os
  # blocks (ComponentsOrder cop), so branch with if OS.* / Hardware::CPU.*.
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/sinew-mocap/osc-tester/releases/download/v0.1.0/osctest-macos-arm64"
    sha256 "955f3c8cb05911151ccc1baca5486f5fb9ed35770e355a6908ac4845f5a68f7e"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/sinew-mocap/osc-tester/releases/download/v0.1.0/osctest-linux-x64"
    sha256 "c03f2d577509179f9ae929bae5d1da4dd7ff92c80fa0a9fcd640f34051129803"
  end

  def install
    # The release asset is a bare executable; Homebrew stages it under its URL
    # basename.  Install it as `osctest` and make sure it's runnable.
    bin.install Dir["*"].first => "osctest"
    chmod 0755, bin/"osctest"
  end

  test do
    assert_predicate bin/"osctest", :executable?
  end
end
