class Termcmp < Formula
  desc "Terminal-native autocomplete engine using PTY proxying for macOS and Linux terminals"
  homepage "https://github.com/emretuna/termcmp"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/emretuna/termcmp/releases/download/v0.1.2/termcmp-aarch64-apple-darwin.tar.xz"
      sha256 "f3e65832e5802117d67d135a3718d094b8c529ba851e45c51b830d262606585d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/emretuna/termcmp/releases/download/v0.1.2/termcmp-x86_64-apple-darwin.tar.xz"
      sha256 "ddd0a3ea3d736b5eb18ade95efd1d682adef1736f968362401eb2a538ad35f6e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/emretuna/termcmp/releases/download/v0.1.2/termcmp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8c67b6019ecb0a3f78be3aa78cd785a02a61ef6d4e4bfdb65104ad0a6bf9f3ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/emretuna/termcmp/releases/download/v0.1.2/termcmp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d2866a5adb69ecc5693fd604f2f6569f2a69e3dc2b5ecda5c821d55b740c066a"
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
