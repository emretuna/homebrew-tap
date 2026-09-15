class Termcmp < Formula
  desc "Terminal-native autocomplete engine using PTY proxying for macOS and Linux terminals"
  homepage "https://github.com/emretuna/termcmp"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/emretuna/termcmp/releases/download/v0.1.1/termcmp-aarch64-apple-darwin.tar.xz"
      sha256 "e4a2fcd545f17e7638b8509d815fd0c152bfd8fb6da711c63c1de0457ee0847b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/emretuna/termcmp/releases/download/v0.1.1/termcmp-x86_64-apple-darwin.tar.xz"
      sha256 "2ed33f4f6f9929dad721064003cfeb92c07fd301af34af4427b3652aeb144ccf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/emretuna/termcmp/releases/download/v0.1.1/termcmp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d6be4419b9d23562e3c8cc7cd9fa415b04ced26d7389b6bb99ebf0a6b0997be8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/emretuna/termcmp/releases/download/v0.1.1/termcmp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c3913228e0f04c1cc974b43e22d30d20a94dfae8e9683cba4b9beb0486bb56fe"
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
