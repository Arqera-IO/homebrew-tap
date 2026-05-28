class TwinFsWatcher < Formula
  desc "Layer-3 filesystem watcher — substrate-citizen for terminal-as-substrate-citizen. Emits typed acts for code, identity, credentials, substrate, deployment, knowledge, commerce, and configuration domains across arqera."
  version "0.3.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.6/twin-fs-watcher-aarch64-apple-darwin.tar.xz"
      sha256 "bd0b62820217124d1706393c63a477258c17a75ea90beb2b84d98aa28cd8ebeb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.6/twin-fs-watcher-x86_64-apple-darwin.tar.xz"
      sha256 "0523463d0ac77487d0b8e81dad2d236e29072f1607bf2653cd94849557bf6551"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.6/twin-fs-watcher-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ded92735cfe66cacceb2e06a13b55c763f8fccf244e031b53efd8f093d08c65e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.6/twin-fs-watcher-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0b94472a31bbff3e1ad46e92c987fc61e3c93eeb76d91c25104e585d476861d8"
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
