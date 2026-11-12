class Annotary < Formula
  desc "Share Markdown with humans and agents, and comment on it together"
  homepage "https://github.com/josh-andrews-dev/annotary"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/josh-andrews-dev/annotary/releases/download/v0.6.2/annotary-aarch64-apple-darwin.tar.gz"
      sha256 "e05f699d21a43378e30909da87d79ab7e74bbb97339082497e54be2222bb8c63"
    end
    if Hardware::CPU.intel?
      url "https://github.com/josh-andrews-dev/annotary/releases/download/v0.6.2/annotary-x86_64-apple-darwin.tar.gz"
      sha256 "3eecf158ff882e278f08b3529e0e070a7ccbd3c8bf396e96fe2e01b02ceafd03"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/josh-andrews-dev/annotary/releases/download/v0.6.2/annotary-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "690c65ae3295866bd16ddb14c1e3396a7ef975fd2fe9646bba3db6288b29514f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/josh-andrews-dev/annotary/releases/download/v0.6.2/annotary-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dc07e6a4fc362ad4837fab9c968ce4eb5d7f54d6dc6891f88c73f734ca3e0a85"
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
