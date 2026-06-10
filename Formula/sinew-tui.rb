# typed: false
# frozen_string_literal: true

# Slim Sinew driver — the rebocap dongle to /sinew OSC bridge with a terminal monitor.
class SinewTui < Formula
  desc "Slim Sinew driver — rebocap dongle to /sinew OSC with a terminal monitor"
  homepage "https://github.com/sinew-mocap/driver"
  url "https://github.com/sinew-mocap/driver/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "aa235b10c74b183d416603660d1f3f880eae7d30bd43d3e217e9a4c47a6b9fd8"
  license "MIT"
  head "https://github.com/sinew-mocap/driver.git", branch: "main"

  depends_on "cmake" => :build

  # ftxui (the TUI lib) is normally fetched by CMake; vendor it as a resource so
  # the build needs no network, and point CMake's FetchContent at it.
  resource "ftxui" do
    url "https://github.com/ArthurSonzogni/FTXUI/archive/refs/tags/v5.0.0.tar.gz"
    sha256 "a2991cb222c944aee14397965d9f6b050245da849d8c5da7c72d112de2786b5b"
  end

  def install
    (buildpath/"ftxui-src").install resource("ftxui")
    system "cmake", "-S", ".", "-B", "build",
           "-DFETCHCONTENT_SOURCE_DIR_FTXUI=#{buildpath}/ftxui-src",
           *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/sinew_tui"
  end

  test do
    assert_match "sinew_tui", shell_output("#{bin}/sinew_tui --version")
  end
end
