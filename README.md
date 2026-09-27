# k-kinzal Homebrew tap

## Syncer

Layered, patch-first file synchronization for macOS and Linux.

```sh
brew install k-kinzal/tap/syncer
syncer --help
```

Official native extensions are installed into `$(brew --prefix syncer)/lib/syncer` but are enabled only by explicit local enrollment:

```sh
# macOS; use .so on Linux
syncer extension install "$(brew --prefix syncer)/lib/syncer/libsyncer_extension_json.dylib"
```

[Source, documentation and releases](https://github.com/k-kinzal/syncer-rs). Formula URLs and SHA-256 digests are generated from release archives using the project's `scripts/homebrew.py`.
