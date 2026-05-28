class AraTwin < Formula
  desc "Reference peer binary for ara-protocol — embeds the kernel, joins the mesh, signs acts, anchors evidence."
  homepage "https://arqera.io"
  version "0.3.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.8/ara-twin-aarch64-apple-darwin.tar.xz"
      sha256 "16f51c1ee9a3cfba52f21c7108c0fcb3a77be781f1ea17a4da14c4b31806a4dc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.8/ara-twin-x86_64-apple-darwin.tar.xz"
      sha256 "688215fde6135e582f285dd4f4ad10a0bf57ed5d178045b88a39587c55203c87"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.8/ara-twin-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d22a3295e2a3b0420b55360ba61993ec7c8517e8e556ea31a4c333ac892aa03a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.8/ara-twin-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "db8908234dbfb794431bbdb3fe050ad3bc90e4bddeb2262fd5dbe7f32fc85093"
    end
  end
  license "BUSL-1.1"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "migrate-doc", "migrate-rules", "twin" if OS.mac? && Hardware::CPU.arm?
    bin.install "migrate-doc", "migrate-rules", "twin" if OS.mac? && Hardware::CPU.intel?
    bin.install "migrate-doc", "migrate-rules", "twin" if OS.linux? && Hardware::CPU.arm?
    bin.install "migrate-doc", "migrate-rules", "twin" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
