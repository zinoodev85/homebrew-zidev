class Zidev < Formula
  desc "Sidebar of Claude Code sessions, grouped by project, on tmux"
  homepage "https://github.com/zinoodev85/zidev"
  url "https://github.com/zinoodev85/zidev/archive/refs/tags/v0.1.12.tar.gz"
  sha256 "f5991adce19dc55e401102aaa84d45dff22e454f6e6b2e1d101adec552dbfe60"
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

  # the app, ready built (Apple silicon and Intel): nothing to compile, no Command Line Tools
  resource "app" do
    url "https://github.com/zinoodev85/zidev/releases/download/v0.1.12/zidev-app.zip"
    sha256 "669f805b308e013965409852d048aaae2561bb15829eeebf1fc2cd090ace74f7"
  end

  def install
    # brew does not quarantine what a formula downloads: macOS opens the app without an Apple signature;
    # brew unpacks the zip into the app itself
    resource("app").stage { (prefix/"zidev.app").install "Contents" }
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
