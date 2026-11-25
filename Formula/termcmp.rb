class Termcmp < Formula
  desc "Terminal-native autocomplete engine using PTY proxying for macOS and Linux terminals"
  homepage "https://github.com/emretuna/termcmp"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/emretuna/termcmp/releases/download/v0.3.0/termcmp-aarch64-apple-darwin.tar.xz"
      sha256 "01572d1d1b74b26d0bf8674da6c6b9d87ce7d907a836453510b0dff1f0f1c16e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/emretuna/termcmp/releases/download/v0.3.0/termcmp-x86_64-apple-darwin.tar.xz"
      sha256 "f38da00d8a8c5d4bd9fff8b9988917c91cb11c2013f1da11fa4e0bd02b4d534d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/emretuna/termcmp/releases/download/v0.3.0/termcmp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8bab477e5d9919b0d42c36b69b017ee928201ec530a92002ee513c7c3dfbd97a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/emretuna/termcmp/releases/download/v0.3.0/termcmp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1755e0fbe9def40dcd0848914381bd40ce1807b33ad29e56a56c60f7fc5c9bcc"
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
