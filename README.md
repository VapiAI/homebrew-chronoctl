# Homebrew tap for Chronoctl

An unofficial, community-maintained Homebrew tap for
[Chronoctl](https://docs.chronosphere.io/tooling/chronoctl), Chronosphere's CLI.
The formula builds the tagged Apache-2.0 source published in
[`chronosphereio/chronoctl-core`](https://github.com/chronosphereio/chronoctl-core).

## Install

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

Then follow Chronosphere's
[authentication documentation](https://docs.chronosphere.io/tooling/chronoctl/install#authentication).
Do not put API tokens in this repository or in formula arguments.

## Update

Chronosphere currently supports Chronoctl versions for one year after release. To
check whether the formula is behind the newest upstream tag:

```sh
brew livecheck --formula VapiAI/chronoctl/chronoctl
```

To update it, change the tag in `url`, the source archive `sha256`, and the
seven-character source revision passed in `ldflags`. Then run the checks below.

## Development

```sh
brew tap VapiAI/chronoctl "$(pwd)"
brew trust --formula VapiAI/chronoctl/chronoctl
brew style --formula VapiAI/chronoctl/chronoctl
brew audit --strict --new --online VapiAI/chronoctl/chronoctl
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
