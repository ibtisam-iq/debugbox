# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.2.0] - 2026-07-16

### Added

#### Site
- Custom 404 page (`overrides/404.html`): branded error page with site header, "Page not found" message, Back to Home and Quick Start buttons, and quick links to Variants, Examples, Troubleshooting, and GitHub Issues
- Image lightbox (`mkdocs-glightbox`): clicking any image opens a full-screen zoomable overlay with keyboard navigation
- `mkdocs-section-index` plugin: section headings in the left nav are now clickable and link to the section overview page without requiring an `index.md` per section
- Material features: `content.tooltips` (abbreviation and link previews), `toc.follow` (active TOC item tracks scroll), `navigation.path` (breadcrumb trail), `content.action.view` (view-source link alongside edit)
- CSS additions: scroll-driven reading progress bar (`body::after`, degrades silently in older browsers); navigation hover and `focus-visible` keyboard outline states; announcement bar theming; typography scale and line-height for `.md-typeset`; inline code indigo tint that does not affect syntax-highlighted blocks; dark-mode code block background contrast fix
- `JetBrains Mono` set as the code font
- Custom personal-site footer icon (`overrides/.icons/personal-site.svg`) replacing the generic globe icon in the social links row
- `exclude_docs: includes/` in `mkdocs.yml`: keeps snippet source files out of the public site navigation
- Markdown extensions: `pymdownx.inlinehilite`, `pymdownx.keys`, `pymdownx.mark`

#### Documentation
- [Interactive tutorial on iximiuz Labs](https://labs.iximiuz.com/tutorials/kubernetes-debugging-with-debugbox-74e481c8) by [@iximiuz](https://labs.iximiuz.com/a/ibtisam-iq): covers live Kubernetes debugging with all three variants end-to-end; linked from the homepage, quick-start, examples, and Kubernetes usage pages
- `docs/includes/abbreviations.md`: new shared abbreviations list (DNS, TLS, TCP, UDP, ICMP, ARP, BPF, MTU, NIC, NSE, QEMU, binfmt, OCI, and more) auto-appended to every page via `pymdownx.snippets`; hovering any defined term shows a tooltip
- Homepage `title` and `description` front matter: controls the browser tab title, search result snippet, and social card heading independently of the global `site_description`

#### Example Manifests
- `terminationGracePeriodSeconds: 0` added to all three example pod manifests (`lite`, `balanced`, `power`) so pods delete immediately on `kubectl delete` without waiting out the default 30-second grace period

### Changed

#### Documentation
- `docs/guides/troubleshooting.md` rewritten from a loose FAQ into a structured numbered guide with 8 sections, a placeholder conventions table, and 20+ specific entries covering image pull failures, pod startup, shell environment, DNS resolution, service connectivity, capability permissions (`NET_RAW`, `NET_ADMIN`), network debugging, and tool-specific behavior (`ltrace`, `nft`, `lsof`, `socat`, `openssl`, `ps`)
- `docs/guides/examples.md` reorganized: every scenario now opens with a prerequisite admonition showing exactly what to deploy before entering the pod; inline code comments explain why commands are constructed the way they are rather than what they do; all examples use consistent pod and service names
- Minor factual and phrasing improvements across `docs/usage/`, `docs/variants/`, `docs/reference/`, and `docs/security/`

#### Shell Helpers
- All helpers (`ports`, `connections`, `routes`, `sniff`, `sniff-http`, `sniff-dns`, `k8s-info`) converted from aliases to shell functions; functions work correctly in non-interactive shells and when the profile is sourced explicitly
- `cert-check()` now accepts hostname and port as separate arguments (`cert-check <host> [port]`, default port 443) and wraps the `openssl s_client` call in `timeout 5` to prevent hanging on unresponsive hosts; previously accepted only a pre-formatted `host:port` string with no timeout
- `conntrack-watch()` replaced: the previous implementation ran `watch -n 2` in a loop printing a connection count line; the new implementation runs `conntrack -L -o extended` once and shows up to 40 entries in extended format, making it pipe-friendly and consistent with the rest of the helper set

#### Site
- Announcement bar now fetches the latest release tag from the GitHub API at page load and updates the link and text dynamically; previously showed a hardcoded version string
- Hero variant cards: each card now has a colored top bar (grey for lite, amber for balanced, red for power); balanced card is visually highlighted as the recommended default
- Tables: added `display: block` and `overflow-x: auto` so wide tables scroll horizontally instead of overflowing the content column
- Removed `header.autohide`: header remains visible at all scroll positions

### Security
- **CVE-2026-39822** (suppressed, HIGH): Go `os.Root` symlink traversal in stdlib; `yq` v4.53.3 is compiled with Go v1.26.4, fixed in Go v1.26.5. No `yq` release with the patched Go version is available as of 2026-07-16. Entry added to `.trivyignore`; will be lifted when `yq` publishes a binary built with Go v1.26.5+.

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
- **`balanced`** (default) – Recommended daily image (~51 MB) adding `bash`, `vim`, `git`, `tcpdump`, `socat`, `mtr`, `htop`, `strace`, `lsof`, `kubectx`, `kubens`
- **`power`** – Comprehensive SRE image (~112 MB) adding `openssl`, `tshark`, `nmap`, `iperf3`, `ltrace`, `iptables`, `nftables`, `conntrack-tools`, and more
- **`base`** – Shared Alpine foundation (~4 MB) with CA certificates and improved shell UX

#### Features
- Multi-architecture support: `linux/amd64` and `linux/arm64` (automatic via manifests)
- Shell enhancements: colored prompt, `ll` alias, `json()` and `yaml()` helpers (lite+), and more
- Published to GitHub Container Registry (`ghcr.io/ibtisam-iq/debugbox*`) and Docker Hub (`mibtisam/debugbox*`)

For full details on variants and included tools, see [`docs/manifest.yaml`](docs/manifest.yaml).

For release process and support policy, see [`RELEASE.md`](RELEASE.md).
For security practices, see [`SECURITY.md`](SECURITY.md).
