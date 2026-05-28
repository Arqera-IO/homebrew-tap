class TwinFsWatcher < Formula
  desc "Layer-3 filesystem watcher — substrate-citizen for terminal-as-substrate-citizen. Emits typed acts for code, identity, credentials, substrate, deployment, knowledge, commerce, and configuration domains across arqera."
  version "0.3.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.8/twin-fs-watcher-aarch64-apple-darwin.tar.xz"
      sha256 "447c477477167adb521ed0a3ce6bb882efe3223445260830dcac59a908ab19fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.8/twin-fs-watcher-x86_64-apple-darwin.tar.xz"
      sha256 "50fa1afc0bef0b87b820e1126533ea17003e2af51e4d653455d7b60f2b10b3df"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.8/twin-fs-watcher-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5f2cfb3c6841c7212c1b1a18c6fb34464fe3a44779868dc62b95da24e1d306f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.8/twin-fs-watcher-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "82871a4489c15db1193021c4930d475e08cd590e3c54746d6537cd40356d7e8b"
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
