class AraTwin < Formula
  desc "Reference peer binary for ara-protocol — embeds the kernel, joins the mesh, signs acts, anchors evidence."
  homepage "https://arqera.io"
  version "0.3.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.6/ara-twin-aarch64-apple-darwin.tar.xz"
      sha256 "ed3d4c708892abf274a6fe556beacdbcade24e84b293bae947db60b6dd18b148"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.6/ara-twin-x86_64-apple-darwin.tar.xz"
      sha256 "320c488f176dbcaf5cfc27a8a3166dc396b0394e7846a3a0063704fc93550052"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.6/ara-twin-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "00b37ef4529c15af0a9b76be00767730f34f6b202cdc909c60719e29bcec379c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.6/ara-twin-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6904ae42896939b01403441131fcaafe0d64e028db2d19a10a42cdfc88705df7"
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
