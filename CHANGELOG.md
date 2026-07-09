# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.0] - 2026-07-09

### Added
- Dedicated `base.yml` workflow to build, scan, and push the base image on its own lifecycle (previously manual)
- Makefile: auto-detect host architecture for PLATFORM default, `make run-<variant>` target, `make lint` now includes Dockerfile.base
- Example pod manifests for lite and balanced variants (`examples/lite-debug-pod.yaml`, `examples/balanced-debug-pod.yaml`)
- GitHub issue templates (bug report, feature request), pull request template
- CODEOWNERS file
- Dependabot configuration for Python dependency updates
- Site redesign: hero homepage with variant cards, indigo+amber color identity, announcement bar, social card generation
- Navigation features: instant loading, back-to-top, search suggestions, header autohide
- Shell helpers `sniff-http`, `sniff-dns`, `cert-check()` moved from power-only to balanced (available in both)

### Changed

#### Variant Tool Curation
- **Balanced:** Add `openssl` (TLS debugging is daily work, not power-only). Remove `wget` (redundant with curl), `ethtool`, `iftop`, `iperf3`, `nmap` (moved to power)
- **Power:** Add `ethtool`, `iftop`, `iperf3`, `nmap` (moved from balanced). Remove `bird`, `bridge-utils`, `nano`, `py3-pip`, `speedtest-cli` (unnecessary bloat)
- Image sizes updated: balanced ~51 MB to ~47 MB, power ~112 MB to ~91 MB

#### Infrastructure
- Bump Alpine base from 3.20 to 3.21
- Bump kubectx/kubens from v0.9.5 to v0.11.0 with golang.org/x/net patched to v0.55.0
- Bump yq from v4.50.1 to v4.53.3, resolving 1 CRITICAL and 16 HIGH vulnerabilities
- Pin all variant Dockerfiles to the base image SHA digest for deterministic builds
- Externalize shell helper profiles from Dockerfiles into `dockerfiles/profiles/` for editability without cache invalidation
- Release workflow restructured into parallel jobs: validate, build-and-scan (amd64), push (multi-arch)
- Tag count corrected from 20 to 22 per release (11 unique patterns x 2 registries)
- Switch CI and base workflows from manual Trivy install to `aquasecurity/trivy-action`
- Upgrade all GitHub Actions to latest major versions
- Pin smoke test dependency to commit SHA

#### Documentation
- Restructure docs: merge installation.md into quick-start.md, remove redundant sections across 15 pages (-356 lines net)
- Fix manifest.yaml: rename `control-plane` category to `data` for yq, correct `conntrack-watch()` to `conntrack-watch`, note curl as inherited in balanced
- Remove emoji from all documentation and repository markdown files
- Correct FAQ: `kubectl debug` requires Kubernetes 1.23+, not 1.18+

### Removed
- `docs/getting-started/installation.md` (content merged into quick-start.md)
- `bird`, `bridge-utils`, `nano`, `py3-pip`, `speedtest-cli` packages from power variant
- `wget` package from balanced variant
- CNAME file (redundant)
- "Acknowledgments" placeholder from security policy

## [1.0.0] - 2026-02-06 

### Added
- Initial stable release of DebugBox – a suite of debugging container images for Kubernetes and Docker environments

#### Image Variants
- **`lite`** – Minimal image (~15 MB) with essential networking tools (`curl`, `netcat`, `iproute2`, `iputils`, `bind-tools`) and data tools (`jq`, `yq`)
- **`balanced`** (default) – Recommended daily image (~47 MB) adding `bash`, `vim`, `git`, `openssl`, `tcpdump`, `socat`, `mtr`, `htop`, `strace`, `lsof`, `kubectx`, `kubens`
- **`power`** – Comprehensive SRE image (~91 MB) adding `tshark`, `nmap`, `iperf3`, `ltrace`, `iptables`, `nftables`, `conntrack-tools`, and more
- **`base`** – Shared Alpine foundation (~4 MB) with CA certificates and improved shell UX

#### Features
- Multi-architecture support: `linux/amd64` and `linux/arm64` (automatic via manifests)
- Shell enhancements: colored prompt, `ll` alias, `json()` and `yaml()` helpers (lite+), and more
- Published to GitHub Container Registry (`ghcr.io/ibtisam-iq/debugbox*`) and Docker Hub (`mibtisam/debugbox*`)

For full details on variants and included tools, see [`docs/manifest.yaml`](docs/manifest.yaml).

For release process and support policy, see [`RELEASE.md`](RELEASE.md).
For security practices, see [`SECURITY.md`](SECURITY.md).
