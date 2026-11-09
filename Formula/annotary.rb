class Annotary < Formula
  desc "Share Markdown with humans and agents, and comment on it together"
  homepage "https://github.com/josh-andrews-dev/annotary"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/josh-andrews-dev/annotary/releases/download/v0.5.0/annotary-aarch64-apple-darwin.tar.gz"
      sha256 "299b7279a4b479c58ff27817669f923289bc6fae123bc47dc776f106be73a6f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/josh-andrews-dev/annotary/releases/download/v0.5.0/annotary-x86_64-apple-darwin.tar.gz"
      sha256 "398e17d499576450d4b3b955f1929f26e8f3c5d64f517c2c1ce6969f10ab69dd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/josh-andrews-dev/annotary/releases/download/v0.5.0/annotary-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "21353f39e3e930861620245110d90061a20522cac9dd2f869aa089661f0af972"
    end
    if Hardware::CPU.intel?
      url "https://github.com/josh-andrews-dev/annotary/releases/download/v0.5.0/annotary-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "32dab6291f14d457e883690b4d75d3cff8e845ec66177a01639f8553845a3784"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

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
      bin.install "annotary"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "annotary"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "annotary"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "annotary"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/annotary --version")
    ENV["ANNOTARY_SETUP_HANDLE"] = "brewtest"
    shell_output("#{bin}/annotary serve --setup-only --data-dir #{testpath}/data < /dev/null")
    assert_path_exists testpath/"data/store/annotary.sqlite"
  end
end
