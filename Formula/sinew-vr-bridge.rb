# typed: false
# frozen_string_literal: true

# Sinew VR bridge — read SteamVR HMD/controller poses and forward them as /vr OSC.
# Ships the prebuilt macOS (arm64) reader binaries from the release.
class SinewVrBridge < Formula
  desc "Sinew VR bridge CLI tools — SteamVR HMD/controller poses to /vr OSC"
  homepage "https://github.com/sinew-mocap/vr_bridge"
  url "https://github.com/sinew-mocap/vr_bridge/releases/download/v0.4.0/sinew-vr-bridge-macos.zip"
  sha256 "b33ba9ae482d635e297ed3bc667578958a1ac178c192507e03549582890d6069"
  version "0.4.0"
  license "MIT"

  def install
    bin.install "hmd_reader", "vr_devices"
  end

  test do
    # The tools attach to a running SteamVR; with none present they exit non-zero
    # rather than hang, so just confirm the binaries are installed and runnable.
    assert_predicate bin/"hmd_reader", :executable?
    assert_predicate bin/"vr_devices", :executable?
  end
end
