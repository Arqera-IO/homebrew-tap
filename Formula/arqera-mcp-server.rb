class ArqeraMcpServer < Formula
  desc "ARQERA MCP server — the distribution channel. Exposes twin + capability + signed-envelope primitives as Model-Context-Protocol tools so every agent talks to the substrate through the open gate, not backdoors."
  homepage "https://github.com/Arqera-IO/ara-protocol"
  version "0.3.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.5/arqera-mcp-server-aarch64-apple-darwin.tar.xz"
      sha256 "36821f5af74f13b17332b0fa38eefd9fea3e93d39e9219c76da60879017bf3ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.5/arqera-mcp-server-x86_64-apple-darwin.tar.xz"
      sha256 "53cd6784da87f487d0df42ab207f4cc903193f8ec8d7c51c0c3d91b6c55fbcee"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.5/arqera-mcp-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e581427d850029ac33d6e5f14ef207b050c333cb90f854ba44806ea046ddd4b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.5/arqera-mcp-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "330abe9cd3adf80314fa1e1a30944d1dd682129aae8cc989a22064e535fba063"
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
