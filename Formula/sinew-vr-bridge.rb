# typed: false
# frozen_string_literal: true

# Sinew VR bridge — read SteamVR HMD/controller poses and forward them as /vr OSC.
# macOS/Windows install the prebuilt reader binaries from the release; Linux has no
# prebuilt artifact, so it builds the same reader tools from source (self-contained
# — the cluster vendors openvr and has no sibling-repo deps).
class SinewVrBridge < Formula
  desc "Read SteamVR HMD/controller poses and forward them as /vr OSC"
  homepage "https://github.com/sinew-mocap/vr_bridge"
  version "0.4.0"
  license "MIT"

  # macOS installs the prebuilt reader binaries from the release; Linux has no
  # prebuilt artifact, so it builds the same tools from the source tarball.
  if OS.mac?
    url "https://github.com/sinew-mocap/vr_bridge/releases/download/v0.4.0/sinew-vr-bridge-macos.zip"
    sha256 "b33ba9ae482d635e297ed3bc667578958a1ac178c192507e03549582890d6069"
  else
    url "https://github.com/sinew-mocap/vr_bridge/archive/refs/tags/v0.4.0.tar.gz"
    sha256 "e0fe6c4ccc9b03a85a937b26f820aba903e21558a4506018607b38dcf4b02653"
  end

  on_linux do
    depends_on "cmake" => :build
  end

  def install
    if OS.mac?
      bin.install "hmd_reader", "vr_devices"
    else
      # The reader tools vendor the openvr api stubs, but the generated stub includes
      # "vr_bridge/adapters/gen/openvr_api_stubs.h" — resolved against the parent dir
      # ($CMAKE_SOURCE_DIR/..) — so the source tree must be named exactly vr_bridge.
      # GitHub's tag tarball unpacks as vr_bridge-0.4.0, so build from a copy that is.
      src = buildpath/"../vr_bridge"
      cp_r buildpath, src
      system "cmake", "-S", src, "-B", src/"build", *std_cmake_args
      system "cmake", "--build", src/"build"
      bin.install src/"build/hmd_reader", src/"build/vr_devices"
    end
  end

  test do
    # The tools attach to a running SteamVR; with none present they exit non-zero
    # rather than hang, so just confirm the binaries are installed and runnable.
    assert_predicate bin/"hmd_reader", :executable?
    assert_predicate bin/"vr_devices", :executable?
  end
end
