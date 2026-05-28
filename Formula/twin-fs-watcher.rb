class TwinFsWatcher < Formula
  desc "Layer-3 filesystem watcher — substrate-citizen for terminal-as-substrate-citizen. Emits typed acts for code, identity, credentials, substrate, deployment, knowledge, commerce, and configuration domains across arqera."
  version "0.3.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.7/twin-fs-watcher-aarch64-apple-darwin.tar.xz"
      sha256 "cf92cc69bdeb4e16c65155e7db8a81be945fba60165bab37809f7b6e388d7e4c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.7/twin-fs-watcher-x86_64-apple-darwin.tar.xz"
      sha256 "ce23b76e31246739e8ab6cb1c0560fff186221c87ae7b6a28c68f954e8a73c60"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.7/twin-fs-watcher-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3aa0f4141c95f92fc16675d66f598f6d4999f65c2052dbdd0010bc0063d36f02"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Arqera-IO/ara-protocol/releases/download/v0.3.7/twin-fs-watcher-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5942c297a1c0ee2bffd13acd9e6bca797754de4abbc1ae542f039327ca553d4a"
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
