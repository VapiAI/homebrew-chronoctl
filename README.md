# Homebrew tap for Chronoctl

An unofficial, community-maintained Homebrew tap for
[Chronoctl](https://docs.chronosphere.io/tooling/chronoctl), Chronosphere's CLI.
The formula builds the tagged Apache-2.0 source published in
[`chronosphereio/chronoctl-core`](https://github.com/chronosphereio/chronoctl-core).

## Install

Install the newest stable upstream tag:

```sh
brew install VapiAI/chronoctl/chronoctl
```

Homebrew automatically taps a fully qualified formula. With Homebrew 6 or newer,
this trusts only this formula rather than every package that may later be added to
the tap.

Verify the installation:

```sh
chronoctl version
```

### Install a specific version

The tap retains the four releases immediately preceding the current release:

```sh
brew install VapiAI/chronoctl/chronoctl@1.32.0
```

Versioned formulae are keg-only because they all provide a binary named
`chronoctl`. Run one directly with:

```sh
"$(brew --prefix VapiAI/chronoctl/chronoctl@1.32.0)/bin/chronoctl" version
```

Or put that version's `bin` directory at the front of `PATH`. List the currently
available rollback versions with:

```sh
brew search '/chronoctl(@|$)/'
```

Then follow Chronosphere's
[authentication documentation](https://docs.chronosphere.io/tooling/chronoctl/install#authentication).
Do not put API tokens in this repository or in formula arguments.

## Updates and version retention

Chronosphere currently supports Chronoctl versions for one year after release. To
check whether the formula is behind the newest upstream tag:

```sh
brew livecheck --formula VapiAI/chronoctl/chronoctl
```

The scheduled `Update Chronoctl` workflow checks the upstream repository daily.
When a newer stable `vX.Y.Z` tag appears, it opens a pull request that updates
`chronoctl`, preserves the displaced release as a versioned formula, and removes
the oldest rollback formula once the four-version retention window is full.

To prepare an update locally or select an explicit newer tag:

```sh
ruby script/update.rb
ruby script/update.rb 1.34.0
```

An install never downloads from a mutable `latest` URL: every formula uses an
immutable Git tag and verified SHA-256 checksum. `brew update` must fetch the
merged formula update before `brew upgrade chronoctl` can install a new release.

## Development

```sh
brew tap VapiAI/chronoctl "$(pwd)"
brew trust --formula VapiAI/chronoctl/chronoctl
brew style --formula VapiAI/chronoctl/chronoctl VapiAI/chronoctl/chronoctl@1.32.0
brew audit --strict --new --online VapiAI/chronoctl/chronoctl
brew audit --strict --online VapiAI/chronoctl/chronoctl@1.32.0
brew install --build-from-source VapiAI/chronoctl/chronoctl
brew test VapiAI/chronoctl/chronoctl
```

The CI workflow runs style, audit, build, and test on macOS and Linux. The formula
uses upstream source instead of mirroring or modifying Chronosphere binaries.

## Scope and support

- This project packages Chronoctl; it does not wrap, proxy, or alter the CLI at runtime.
- Chronosphere owns and supports Chronoctl. Report CLI behavior and authentication
  issues through Chronosphere's support channels.
- Report formula, installation, and update issues in this repository.
- This project is not affiliated with, endorsed by, or sponsored by Chronosphere.
  Chronosphere and Chronoctl may be trademarks of Chronosphere, Inc.

See [RESEARCH.md](RESEARCH.md) for the packaging decision, constraints, and prior art.
