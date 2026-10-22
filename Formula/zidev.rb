class Zidev < Formula
  desc "Sidebar of Claude Code sessions, grouped by project, on tmux"
  homepage "https://github.com/zinoodev85/zidev"
  url "https://github.com/zinoodev85/zidev/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "c7f374dd94993c562569638bf42a05b08b416f048a6e2b1c2fc1ba9b2b73289b"
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
    url "https://github.com/zinoodev85/zidev/releases/download/v0.1.7/zidev-app.zip"
    sha256 "7e7f43e71436a21801918a22704bf1c64fb416085619acd502ad1ec3c4bfd38e"
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
