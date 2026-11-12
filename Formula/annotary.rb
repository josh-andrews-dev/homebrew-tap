class Annotary < Formula
  desc "Share Markdown with humans and agents, and comment on it together"
  homepage "https://github.com/josh-andrews-dev/annotary"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/josh-andrews-dev/annotary/releases/download/v0.6.1/annotary-aarch64-apple-darwin.tar.gz"
      sha256 "e6d1e184db4bba005b70d9ad0f6141b1e7e9123785c55a8a7a59c967b07cdfde"
    end
    if Hardware::CPU.intel?
      url "https://github.com/josh-andrews-dev/annotary/releases/download/v0.6.1/annotary-x86_64-apple-darwin.tar.gz"
      sha256 "6b415fc811202feb0315177059a282c4bdd73b4e887da8bd09bb6a495ace43c8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/josh-andrews-dev/annotary/releases/download/v0.6.1/annotary-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "14bce393cce8d2fe9bcdca20a24e988ee24a054ca8eeddc8a9a80e293b121c8a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/josh-andrews-dev/annotary/releases/download/v0.6.1/annotary-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5ef11203ec7a2bd12bdc86aae004584a9103b199688602acb52975748f70f5c6"
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
