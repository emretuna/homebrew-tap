class Termcmp < Formula
  desc "Terminal-native autocomplete engine using PTY proxying for macOS and Linux terminals"
  homepage "https://github.com/emretuna/termcmp"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/emretuna/termcmp/releases/download/v0.1.1/termcmp-aarch64-apple-darwin.tar.xz"
      sha256 "389ab3533bc639ba38d4ac4ab45498523988020f753cdde75cad2e0be59bc55b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/emretuna/termcmp/releases/download/v0.1.1/termcmp-x86_64-apple-darwin.tar.xz"
      sha256 "4b6778ce6568bf53aabb6e326068a4fd284f598da5a8290c960f6d303c676f6c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/emretuna/termcmp/releases/download/v0.1.1/termcmp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7d378174e89d0988f4e6e352f4d9cdba69d6dc6bc9892088b8911e9ec9ccc1ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/emretuna/termcmp/releases/download/v0.1.1/termcmp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "11b1869fe611f4774838ca865d5ac8e0a694a88de0cbbbdf666715c3ecae8a88"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "termcmp"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "termcmp"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "termcmp"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "termcmp"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
