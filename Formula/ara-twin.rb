class AraTwin < Formula
  desc "Reference peer binary for ara-protocol — embeds the kernel, joins the mesh, signs acts, anchors evidence."
  homepage "https://arqera.io"
  version "0.3.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.7/ara-twin-aarch64-apple-darwin.tar.xz"
      sha256 "22b17150a7809e82cb71efd03b486571a05f1b34b84a65a0969a3bc3c3ad8c10"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.7/ara-twin-x86_64-apple-darwin.tar.xz"
      sha256 "c036b6ccea3955b1970b0f1dc26398e72044be975879323072b5aec9c018adfa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.7/ara-twin-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "896c6d2e04b263f0b78f97282eab57e4e70dfc70229f822ebd315e666c41025a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.7/ara-twin-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dc92002013c189ae785fe50652137de988275187f6abc1fa3ff603ab2977d93a"
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
