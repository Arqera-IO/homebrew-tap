class TwinFsWatcher < Formula
  desc "Layer-3 filesystem watcher — substrate-citizen for terminal-as-substrate-citizen. Emits typed acts for code, identity, credentials, substrate, deployment, knowledge, commerce, and configuration domains across arqera."
  version "0.3.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.5/twin-fs-watcher-aarch64-apple-darwin.tar.xz"
      sha256 "e0d7663caeb086e792e0811e1d2b939e5469ad1a838d95f21a5525a5c46dcf5a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.5/twin-fs-watcher-x86_64-apple-darwin.tar.xz"
      sha256 "bccbb18e9486728012c0e0c9e6ed7bd6b921bd12ddfe4dd7e03f1380efcb3093"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.5/twin-fs-watcher-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3588d59bf84b8a1ac974b8db12fd5998098238eb015e728e22c52dd91d04a7a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.5/twin-fs-watcher-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aa5efe0a9814ce8c5dce5a27b2f1f48dd037e0775d357f7c319718b843776d65"
    end
  end

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
    bin.install "twin-fs-watcher" if OS.mac? && Hardware::CPU.arm?
    bin.install "twin-fs-watcher" if OS.mac? && Hardware::CPU.intel?
    bin.install "twin-fs-watcher" if OS.linux? && Hardware::CPU.arm?
    bin.install "twin-fs-watcher" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
