class ArqeraMcpServer < Formula
  desc "ARQERA MCP server — the distribution channel. Exposes twin + capability + signed-envelope primitives as Model-Context-Protocol tools so every agent talks to the substrate through the open gate, not backdoors."
  homepage "https://github.com/Arqera-IO/ara-protocol"
  version "0.3.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.8/arqera-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "533fca23618e8d14fad65e931d4babdda231d09229284842aaa544c1534636e1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.8/arqera-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "9b52901ec4a5dc03a8de39d546c0597893f284dc4293456d2fd19506ca05ce01"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.8/arqera-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "af39d27244fa27749258cf5545f90931eaadb9e4cb587c788a7afc054c651666"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.8/arqera-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "15b6ee398ec30543d783bb83bee5b0747c360e6b0a1eeb99561e468e0b61c3db"
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
