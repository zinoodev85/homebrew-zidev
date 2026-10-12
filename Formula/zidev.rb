class Zidev < Formula
  desc "Sidebar of Claude Code sessions, grouped by project, on tmux"
  homepage "https://github.com/zinoodev85/zidev"
  url "https://github.com/zinoodev85/zidev/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "a25b5b029029a885bece2ff17397dd2ef7ae9b787ad95c06c95802eccbc1b58d"
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
    url "https://github.com/zinoodev85/zidev/releases/download/v0.1.2/zidev-app.zip"
    sha256 "7d7710b3c4c3ffdaefa88e73a0630a3ccb251881de7dd048f4ba8de819dc6c42"
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
