class Termcmp < Formula
  desc "Terminal-native autocomplete engine using PTY proxying for macOS and Linux terminals"
  homepage "https://github.com/emretuna/termcmp"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/emretuna/termcmp/releases/download/v0.1.2/termcmp-aarch64-apple-darwin.tar.xz"
      sha256 "fa25ec4d221ee9bcdce4441e3db9c0b59146fcfe47c07303a3b068d363ac6463"
    end
    if Hardware::CPU.intel?
      url "https://github.com/emretuna/termcmp/releases/download/v0.1.2/termcmp-x86_64-apple-darwin.tar.xz"
      sha256 "2bb9dc5ae362181dc2312bf839dc8e10b841360ea434246e6778275b2a087153"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/emretuna/termcmp/releases/download/v0.1.2/termcmp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "132a390fac2c63022a7587822e676229c34faed8304036f340c482d0f3103344"
    end
    if Hardware::CPU.intel?
      url "https://github.com/emretuna/termcmp/releases/download/v0.1.2/termcmp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d82da785b94507d13ba5cbe5e16668168eff31e5c5a01bb47ed2d19cb4b245b5"
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
