class ArqeraMcpServer < Formula
  desc "ARQERA MCP server — the distribution channel. Exposes twin + capability + signed-envelope primitives as Model-Context-Protocol tools so every agent talks to the substrate through the open gate, not backdoors."
  homepage "https://github.com/Arqera-IO/ara-protocol"
  version "0.3.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.7/arqera-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "6b40d9f4be647d1d71e99ef3d6965349850a07d780e448ce9c35849545c9a109"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.7/arqera-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "75592cbb275c211c78630bcaabd5272cc978d41129226553f37f259d41502c6f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.7/arqera-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "09478994d04e963b35517de163a9ba710e6bcabd2d9b4e6442ffef34091ff333"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.7/arqera-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "968300f3996ecee276b85840c32392e1e393f57832fec8f6b8307c2166134dcd"
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
    bin.install "arqera-mcp-server" if OS.mac? && Hardware::CPU.arm?
    bin.install "arqera-mcp-server" if OS.mac? && Hardware::CPU.intel?
    bin.install "arqera-mcp-server" if OS.linux? && Hardware::CPU.arm?
    bin.install "arqera-mcp-server" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
