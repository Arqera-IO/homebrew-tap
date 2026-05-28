class ArqeraMcpServer < Formula
  desc "ARQERA MCP server — the distribution channel. Exposes twin + capability + signed-envelope primitives as Model-Context-Protocol tools so every agent talks to the substrate through the open gate, not backdoors."
  homepage "https://github.com/Arqera-IO/ara-protocol"
  version "0.3.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.6/arqera-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "d6de58e2e191a3048df302285e688a5e2b7057d54c2ec1bc0f868e167a1073bc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.6/arqera-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "f472d7a43d56f62f1f4096e37053229dbc9257fe94d15e5452148d94a47f2157"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.6/arqera-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "789f97f6cd16410cd7ec58cb91fb261523dd83241d95f005d85813cf08e3a555"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.6/arqera-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ab8eb08fe83e09108c0e376394bb9f3c75f98f765823e086e32fcca56bceebe9"
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
