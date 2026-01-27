# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),  
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-01-27

### Added
- Initial stable release of DebugBox – a suite of debugging container images for Kubernetes and Docker environments

#### Image Variants
- **`lite`** – Minimal image (~15 MB) with essential networking tools (`curl`, `netcat`, `iproute2`, `iputils`, `bind-tools`) and data tools (`jq`, `yq`)
- **`balanced`** (default) – Recommended daily image (~48 MB) adding `bash`, `vim`, `git`, `tcpdump`, `socat`, `nmap`, `mtr`, `htop`, `strace`, `lsof`, `kubectx`, `kubens`
- **`power`** – Comprehensive SRE image (~110 MB) adding `tshark`, `ltrace`, `nano`, `speedtest-cli`, `iptables`, `nftables`, `py3-pip`, and more
- **`base`** – Shared Alpine foundation (~5 MB) with CA certificates and improved shell UX

#### Features
- Multi-architecture support: `linux/amd64` and `linux/arm64` (automatic via manifests)
- Shell enhancements: colored prompt, `ll` alias, `json()` and `yaml()` helpers (lite+)
- Published to GitHub Container Registry (`ghcr.io/ibtisam-iq/debugbox*`) and Docker Hub (`mibtisam/debugbox*`)

For full details on variants and included tools, see [`docs/manifest.yaml`](docs/manifest.yaml).

For release process and support policy, see [`RELEASE.md`](RELEASE.md).  
For security practices, see [`SECURITY.md`](SECURITY.md).
