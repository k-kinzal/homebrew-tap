class Syncer < Formula
  desc "Layered, patch-first file policy synchronization"
  homepage "https://github.com/k-kinzal/syncer-rs"
  license "MIT"
  version "0.1.0"
  on_macos do
    on_arm do
      url "https://github.com/k-kinzal/syncer-rs/releases/download/v0.1.0/syncer-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "11583884930060a81b15921fc0a8cb6122ccc577bcc91b77897c74db75526d5c"
    end
    on_intel do
      url "https://github.com/k-kinzal/syncer-rs/releases/download/v0.1.0/syncer-0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "ae040a3b553b9f9b7090ad88a50f49cebbdda84180f4fee9ccc646d3d821c828"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/k-kinzal/syncer-rs/releases/download/v0.1.0/syncer-0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "328276a6b1069a79d00affcb62734c4ccdbc3e70ce5a48a75204e54a2c2fb637"
    end
    on_intel do
      url "https://github.com/k-kinzal/syncer-rs/releases/download/v0.1.0/syncer-0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "abb97ce4cb5565fdd462fb4085898898fac5c872fee4a1b3657bd2b3c3daf6d7"
    end
  end

  def install
    bin.install "syncer"
    (lib/"syncer").install Dir["libsyncer_extension_*.{dylib,so}"]
    doc.install "README.md"
  end

  def caveats
    <<~EOS
      Enable only the native extensions you trust:
        syncer extension install #{lib}/syncer/libsyncer_extension_json.#{OS.mac? ? "dylib" : "so"}
    EOS
  end

  test do
    (testpath/"policy.hcl").write <<~HCL
      schema_version = 1
      name = "test"
      rule "file" {
        target = "result.txt"
        kind = "file"
        operation = "replace"
        value = "synced"
      }
    HCL
    system bin/"syncer", "--state-dir", testpath/"state", "add", "test", testpath/"policy.hcl"
    system bin/"syncer", "--state-dir", testpath/"state", "apply", "--dry-run"
    refute_path_exists testpath/"result.txt"
    system bin/"syncer", "--state-dir", testpath/"state", "apply"
    assert_equal "synced", (testpath/"result.txt").read
  end
end
