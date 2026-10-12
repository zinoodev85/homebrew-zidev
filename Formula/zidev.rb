class Zidev < Formula
  desc "Sidebar of Claude Code sessions, grouped by project, on tmux"
  homepage "https://github.com/zinoodev85/zidev"
  url "https://github.com/zinoodev85/zidev/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "48d622f031f25b9d5bfb4062e67377847a055bb50ec91cc47f10d7ecf3c6595b"
  license "MIT"

  depends_on "bat"
  depends_on "eza"
  depends_on "fd"
  depends_on "fzf"
  depends_on "git-delta"
  depends_on "glow"
  depends_on :macos
  depends_on "micro"
  depends_on "python@3.14"
  depends_on "ripgrep"
  depends_on "tmux"

  def install
    # zidev.app, built here: macOS runs an app built on this Mac without an Apple signature
    system "app/build.sh"
    prefix.install "app/build/zidev.app"
    python = formula_opt_bin("python@3.14")/"python3.14"
    inreplace "zidev", /\A#!.*$/, "#!#{python}"
    libexec.install "zidev", "tmux.conf", "intent.md"
    bin.install_symlink libexec/"zidev"
  end

  def caveats
    <<~EOS
      zidev runs Claude Code; install it if you have not:
        brew install --cask claude-code
      Then start it with `zidev`, and check the setup with `zidev doctor`.
      zidev as a Mac app of its own (window, Dock icon): `zidev app`
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zidev --version")
    assert_path_exists prefix/"zidev.app/Contents/MacOS/zidev"
  end
end
