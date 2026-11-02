class Annotary < Formula
  desc "Share Markdown with humans and agents, and comment on it together"
  homepage "https://github.com/josh-andrews-dev/annotary"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/josh-andrews-dev/annotary/releases/download/v0.3.2/annotary-aarch64-apple-darwin.tar.gz"
      sha256 "5128c4a2a7de320d0f0b309783028f229008f9be6514f8201852815c8d15e975"
    end
    if Hardware::CPU.intel?
      url "https://github.com/josh-andrews-dev/annotary/releases/download/v0.3.2/annotary-x86_64-apple-darwin.tar.gz"
      sha256 "93702d6fd59ed6c70f54d5a06ea4f833c7db739a6728910e9f58e5904d6917bb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/josh-andrews-dev/annotary/releases/download/v0.3.2/annotary-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c0b1e2ced8fd371c1d7ed9995d8d2ed19dd97f6cce630d77a1912244af9ae624"
    end
    if Hardware::CPU.intel?
      url "https://github.com/josh-andrews-dev/annotary/releases/download/v0.3.2/annotary-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f7c699f76f0bb128def0b3478b14e6eac4a4222e841d77d523b86f414d9672db"
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
