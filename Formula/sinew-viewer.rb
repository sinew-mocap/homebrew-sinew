# typed: false
# frozen_string_literal: true

# Sinew ANNY body viewer — a polyscope GUI driven by /sinew and /vr OSC.
# macOS/Windows install the prebuilt anny_demo bundle from the release; Linux has no
# prebuilt artifact, so it builds from source.  The build needs the two sibling
# clusters (solve -> mount_drift) laid out beside the viewer source, the X11/GL stack
# polyscope's GLFW links, and the soma_pheno.bin phenotype model (a 110 MB runtime
# asset kept out of git, fetched compressed from the data-asset release).
class SinewViewer < Formula
  desc "Live ANNY body viewer driven by /sinew and /vr OSC"
  homepage "https://github.com/sinew-mocap/viewer"
  version "0.4.1"
  license "MIT"

  # macOS installs the prebuilt anny_demo bundle from the release; Linux has no
  # prebuilt artifact, so it builds from the source tarball.
  if OS.mac?
    url "https://github.com/sinew-mocap/viewer/releases/download/v0.4.1/sinew-viewer-macos.zip"
    sha256 "5deb6980220172a20af3b4ceebfc67e15ee872c41deddb0c29d78d1febc890d4"
  else
    url "https://github.com/sinew-mocap/viewer/archive/refs/tags/v0.4.1.tar.gz"
    sha256 "86c90fc9d242e299fd85cb5eb1616d1a239e6637ac38d829540f9e020534b5a3"
  end

  on_linux do
    depends_on "cmake" => :build
    depends_on "zstd" => :build
    # polyscope vendors GLFW, which links the X11 stack and desktop GL at build time.
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxrandr"
    depends_on "mesa" # GL/gl.h + libGL

    # The viewer CMake links the body-solve cluster, which in turn links the GPU
    # cluster; both are pinned to the commits CI builds against.  Laid out as
    # ../solve and ../mount_drift beside the viewer source (the paths CMake hardcodes).
    resource "solve" do
      url "https://github.com/sinew-mocap/solve/archive/a2bda1b2d173dbea5c1f6022300cc8f63af75be1.tar.gz"
      sha256 "7eed21bf8cc8a3f344ee3be3c778fdac1c7f975bc7c95232f377e8a5987de098"
    end

    resource "mount_drift" do
      url "https://github.com/sinew-mocap/mount_drift/archive/e511a4daba6c67db807320bb75e8d101fd270c25.tar.gz"
      sha256 "91964bf1d7defa7d9c5d7d73461fcc2433bd59554e32f87d2a312ba1ca3e3bfe"
    end

    # The ANNY phenotype model — bundled next to anny_demo so it renders the full body.
    resource "soma_pheno" do
      url "https://github.com/sinew-mocap/viewer/releases/download/v1/soma_pheno.bin.zst"
      sha256 "2dd4300acb2ad27375d980e2542f000694010c96696c221d378d47c053304166"
    end
  end

  def install
    if OS.mac?
      # The release bundle carries anny_demo + the two runtime assets at its root;
      # anny_demo resolves them next to its own executable.
      bin.install "anny_demo", "lbs.spv", "soma_pheno.bin"
      return
    end

    # Lay the sibling clusters out where the viewer's CMake expects them: solve at
    # ../solve and mount_drift at ../mount_drift relative to the viewer source root.
    resource("solve").stage(buildpath/"../solve")
    resource("mount_drift").stage(buildpath/"../mount_drift")

    # Decompress the phenotype model into assets/ so the build copies it beside
    # anny_demo (the CMake bundles assets/soma_pheno.bin only when it is present).
    (buildpath/"assets").mkpath
    resource("soma_pheno").stage do
      # Homebrew may auto-decompress a lone .zst; cover both the raw and decoded case.
      if File.exist?("soma_pheno.bin")
        cp "soma_pheno.bin", buildpath/"assets/soma_pheno.bin"
      else
        system "zstd", "-d", "soma_pheno.bin.zst", "-o", buildpath/"assets/soma_pheno.bin"
      end
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    # anny_demo resolves lbs.spv + soma_pheno.bin next to its own executable; the
    # build's POST_BUILD step copied both into the build dir beside anny_demo.
    bin.install "build/anny_demo", "build/lbs.spv"
    bin.install "build/soma_pheno.bin" if File.exist?("build/soma_pheno.bin")
  end

  test do
    # anny_demo opens a polyscope window and binds OSC sockets, so a headless test
    # cannot run it; confirm the binary installs and is runnable.
    assert_predicate bin/"anny_demo", :executable?
  end
end
