# Homebrew packaging research

Research checked on 2026-08-26.

## Recommendation

Maintain a third-party tap named `homebrew-chronoctl` with a source-built formula.
The repository prefix lets users refer to the tap as `OWNER/chronoctl`, while the
fully qualified package is `OWNER/chronoctl/chronoctl`.

Chronosphere's installation page documents four prebuilt binaries: macOS and Linux,
each for amd64 and arm64. Those downloads are exposed under mutable `latest` URLs.
Although Google Cloud Storage generation IDs can temporarily make those objects
immutable, building the tagged source is preferable because:

- the full CLI source is public under Apache-2.0;
- current releases have stable Git tags;
- one formula works across the four documented platforms;
- Homebrew's guidance classifies open-source command-line tools as formulae; and
- the tap does not need to redistribute or mirror vendor binaries.

The current formula packages v1.33.0 at upstream revision `620f8f0`, the same
revision reported by Chronosphere's v1.33.0 binary.

## Limitations and risks

1. **Unofficial distribution.** A third-party tap does not imply Homebrew or
   Chronosphere endorsement. Package-maintenance bugs belong to this repository;
   product bugs remain upstream.
2. **Trust.** Homebrew 6 requires trust for non-official taps. Installing the fully
   qualified formula directly grants item-level trust; users should avoid trusting
   an entire tap unless they accept all current and future code in it.
3. **Maintenance lag.** Chronosphere publishes new tags but does not currently
   publish a release asset/checksum manifest on each GitHub release. A maintainer
   must detect each tag, update the archive checksum and revision, and test it.
4. **Build cost.** Source installation downloads Go modules and compiles a large Go
   dependency graph. Without bottles, installs are slower than Chronosphere's direct
   binary download and require the Homebrew Go build dependency.
5. **Bottles.** A third-party tap can build bottles with GitHub Actions, but securely
   publishing and maintaining bottles adds CI, artifact-hosting, signing/trust, and
   review work. This initial repository intentionally builds from source.
6. **Official Homebrew eligibility.** The upstream project has a public homepage,
   Apache-2.0 source, stable tags, and currently appears to meet Homebrew's baseline
   third-party-submission notability threshold through watcher count. Acceptance is
   discretionary, and the formula must pass strict audit and review. If accepted in
   `homebrew/core`, Homebrew would prefer it remain there rather than redirect users
   to an upstream or third-party tap.
7. **Upstream changes.** The formula relies on the source tree, Go module metadata,
   build entrypoint, and build-info package remaining compatible. Each release must
   be retested; tagged source and vendor binaries should be compared when behavior
   matters.
8. **Brand and relationship.** Do not imply authorization or endorsement. Keep the
   disclaimer prominent, do not use vendor logos, and honor any request from
   Chronosphere concerning trademarks or distribution.
9. **Credentials.** Installation needs no Chronosphere token. Runtime use does; API
   tokens must stay outside Homebrew metadata, logs, tests, and this repository.

## Prior art

Packaging software maintained by another organization is normal in Homebrew:

- `homebrew/core` and `homebrew/cask` are community-maintained catalogs of third-party
  software rather than repositories containing only Homebrew-authored programs.
- Homebrew explicitly says anyone may create a tap and that software not accepted in
  official repositories can generally live in a third-party tap.
- Community packaging can coexist with vendor-owned taps. HashiCorp documents the
  distinction between community-built Homebrew packages and its vendor-maintained tap.
- Chronosphere itself already owns `chronosphereio/calyptia-homebrew-tap` for another
  CLI, demonstrating that the organization is familiar with the tap pattern, although
  that repository is first-party rather than community maintained.
- A prior community Nix example packages the same four Chronoctl downloads, showing
  third-party packaging interest outside Homebrew.

The practical boundary is representation: maintaining public packaging is ordinary;
claiming it is official, redistributing artifacts without license permission, or
using protected branding misleadingly is not.

## Primary references

- [Chronosphere: Install Chronoctl](https://docs.chronosphere.io/tooling/chronoctl/install)
- [Chronosphere: chronoctl-core](https://github.com/chronosphereio/chronoctl-core)
- [Homebrew: Adding Software](https://docs.brew.sh/Adding-Software-to-Homebrew)
- [Homebrew: How to Create and Maintain a Tap](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap)
- [Homebrew: Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
- [Homebrew: Package Acceptance Policy](https://docs.brew.sh/Package-Acceptance-Policy)
- [Homebrew: Tap Trust](https://docs.brew.sh/Tap-Trust)
- [Homebrew: Support Tiers](https://docs.brew.sh/Support-Tiers)
- [HashiCorp's vendor-maintained tap](https://github.com/hashicorp/homebrew-tap)
- [Chronosphere's Calyptia tap](https://github.com/chronosphereio/calyptia-homebrew-tap)
