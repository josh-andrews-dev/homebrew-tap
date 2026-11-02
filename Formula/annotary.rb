class Annotary < Formula
  desc "Share Markdown with humans and agents, and comment on it together"
  homepage "https://github.com/josh-andrews-dev/annotary"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/josh-andrews-dev/annotary/releases/download/v0.3.1/annotary-aarch64-apple-darwin.tar.gz"
      sha256 "f6260648092412998543245d9d6a2d43dd2489c4ea576e90f776b4134d1b2156"
    end
    if Hardware::CPU.intel?
      url "https://github.com/josh-andrews-dev/annotary/releases/download/v0.3.1/annotary-x86_64-apple-darwin.tar.gz"
      sha256 "ab8993292bd9f5362d615beefc79e5844e5a24dfe0bbf50c62daa04213149a1f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/josh-andrews-dev/annotary/releases/download/v0.3.1/annotary-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6ed12d96d4a2f2836e09df969b032502772725e3fe414e6408a2f687f791a920"
    end
    if Hardware::CPU.intel?
      url "https://github.com/josh-andrews-dev/annotary/releases/download/v0.3.1/annotary-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1f877713a1c8f5855842a1ebbcbcc5d725ba0c7e202a006c97f34cb297d81a5a"
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
