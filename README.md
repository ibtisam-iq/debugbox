# DebugBox

**Pipelines**

[![CI](https://github.com/ibtisam-iq/debugbox/actions/workflows/ci.yml/badge.svg)](https://github.com/ibtisam-iq/debugbox/actions/workflows/ci.yml)
[![Docs](https://github.com/ibtisam-iq/debugbox/actions/workflows/docs.yml/badge.svg)](https://github.com/ibtisam-iq/debugbox/actions/workflows/docs.yml)

**Release & Versioning**

[![Latest Release](https://img.shields.io/github/v/release/ibtisam-iq/debugbox?label=latest%20release)](https://github.com/ibtisam-iq/debugbox/releases)
[![Semantic Versioning](https://img.shields.io/badge/Semantic%20Versioning-2.0.0-blue.svg)](https://semver.org/)

**Container Registries**

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-mibtisam%2Fdebugbox-blue?logo=docker)](https://hub.docker.com/r/mibtisam/debugbox)
[![GHCR](https://img.shields.io/badge/GHCR-ghcr.io%2Fibtisam--iq%2Fdebugbox-blue?logo=github)](https://github.com/ibtisam-iq/debugbox/pkgs/container/debugbox)

**Image Sizes**

[![Image Size - Lite](https://img.shields.io/badge/lite-15MB-blue?logo=docker)](https://github.com/ibtisam-iq/debugbox)
[![Image Size - Balanced](https://img.shields.io/badge/balanced-48MB-blue?logo=docker)](https://github.com/ibtisam-iq/debugbox)
[![Image Size - Power](https://img.shields.io/badge/power-110MB-blue?logo=docker)](https://github.com/ibtisam-iq/debugbox)

**Distribution**

[![Docker Pulls](https://img.shields.io/docker/pulls/mibtisam/debugbox?logo=docker)](https://hub.docker.com/u/mibtisam)
[![Multi-Arch](https://img.shields.io/badge/Multi--Arch-amd64%20%7C%20arm64-blue?logo=docker)](https://github.com/ibtisam-iq/debugbox)

**Security & Quality**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Trivy Scanning](https://img.shields.io/badge/Trivy-Scanning-blue?logo=aqua)](https://github.com/aquasecurity/trivy)
[![Powered by Alpine](https://img.shields.io/badge/Powered%20by-Alpine%20Linux-0D597F?logo=alpine-linux)](https://alpinelinux.org/)

**Community & Contribution**

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baadc.svg)](CODE_OF_CONDUCT.md)
[![GitHub Stars](https://img.shields.io/github/stars/ibtisam-iq/debugbox?style=flat&logo=github&logoColor=white)](https://github.com/ibtisam-iq/debugbox/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/ibtisam-iq/debugbox?style=flat&logo=github&logoColor=white)](https://github.com/ibtisam-iq/debugbox/network/members)
[![GitHub Issues](https://img.shields.io/github/issues/ibtisam-iq/debugbox?logo=github)](https://github.com/ibtisam-iq/debugbox/issues)

**Platform Support**

[![Kubernetes Ready](https://img.shields.io/badge/Kubernetes-Ready-326ce5?logo=kubernetes)](https://kubernetes.io/)

**A lightweight, variant-based debugging container suite** for Kubernetes and Docker environments.

Pull **only what you need** — from 15 MB quick checks to 110 MB full forensics.

| Variant       | Size      | Best For                              | Image (GHCR)                                      |
|---------------|-----------|---------------------------------------|---------------------------------------------------|
| **lite**      | ~15 MB   | Network/DNS checks                    | `ghcr.io/ibtisam-iq/debugbox-lite`               |
| **balanced** (default) | ~48 MB   | Daily Kubernetes debugging            | `ghcr.io/ibtisam-iq/debugbox`                    |
| **power**     | ~110 MB  | Packet capture & deep forensics        | `ghcr.io/ibtisam-iq/debugbox-power`              |

Also on Docker Hub: `mibtisam/debugbox*` · Supports **amd64 + arm64**

---

## Table of Contents

- [Quick Start](#quick-start)
- [Why DebugBox?](#why-debugbox)
- [Features](#features)
- [Variants](#variants)
- [Image Tags & Registries](#image-tags--registries)
- [Comparison](#comparison-to-alternatives)
- [What DebugBox Is NOT](#what-debugbox-is-not)
- [Usage](#usage)
- [Local Development](#local-development)
- [Full Documentation](#full-documentation)
- [Troubleshooting & FAQ](#troubleshooting--faq)
- [Security](#security)
- [Contributing](#contributing)
- [License](#license)

---

## Quick Start

```bash
# Debug a running pod (recommended)
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox

# Standalone session
kubectl run debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never
```

Inside: `curl`, `dig`, `tcpdump`, `vim`, `strace`, `kubectx`, and more.

---

## Why DebugBox?

Modern pods lack basic tools:

```bash
kubectl exec -it my-pod -- curl
# curl: not found
```

`netshoot` is powerful but **208 MB** — too heavy for simple checks.

DebugBox gives you **three focused variants** for faster pulls and faster debugging.

---

## Features

- **Variant-based design** — lite (15 MB), balanced (48 MB), power (110 MB)
- **Multi-architecture** — seamless on amd64, arm64 (Apple Silicon, Graviton)
- **Deterministic builds** — critical tools pinned + SHA-verified
- **Security scanned** — Trivy blocks HIGH/CRITICAL on every release
- **Kubernetes-ready** — optimized for `kubectl debug` and ephemeral containers
- **No bloat** — each variant includes only what it promises

---

## Variants

See full comparison and tool list: **[Variants](https://debugbox.ibtisam-iq.com/latest/variants/overview/)**

---

## Image Tags & Registries

- **Primary**: GHCR (`ghcr.io/ibtisam-iq/debugbox*`)
- **Mirror**: Docker Hub (`mibtisam/debugbox*`)

**Tagging**:
- Semantic versions: `v1.0.0`, `v1.0.1`
- `:latest` → newest stable
- Unqualified name → **balanced** variant

**Best practice**:
- Interactive: `:latest`
- Production/CI: pinned `vX.Y.Z`

→ Details: **[Image Tags](https://debugbox.ibtisam-iq.com/latest/reference/tags/)**

---

## Comparison to Alternatives

```
netshoot:        208 MB ████████████████████ 100%
DebugBox power:  110 MB ██████████ 53%
DebugBox balanced: 48 MB █████ 23%
DebugBox lite:    15 MB ██ 7%
busybox:          1.5 MB  <1%
```

| Tool          | Smallest Size | Variants | Multi-Arch | Pinned Tools | Kubernetes Helpers |
|---------------|---------------|----------|------------|--------------|--------------------|
| **DebugBox**  | 15 MB         | ✓ (3)    | ✓          | ✓            | ✓                  |
| netshoot      | 208 MB        | ✗        | ✓          | ✗            | ✗                  |
| busybox       | 1.5 MB        | ✗        | ✓          | ✗            | ✗                  |

DebugBox is up to **93% smaller** than netshoot for common tasks.

---

## What DebugBox Is NOT

- Not a persistent sidecar (use ephemeral `kubectl debug`)
- Not production workload ready (runs as root)
- Not a Kubernetes client (no `kubectl` — intentionally)
- Not a security scanner

It's a **focused debugging toolbox**.

---

## Usage

Full guides:

- **[Kubernetes Usage](https://debugbox.ibtisam-iq.com/latest/usage/kubernetes/)**
- **[Docker Usage](https://debugbox.ibtisam-iq.com/latest/usage/docker/)**
- **[Common Workflows](https://debugbox.ibtisam-iq.com/latest/guides/examples/)**

---

## Local Development

```bash
git clone https://github.com/ibtisam-iq/debugbox.git
cd debugbox

make build-all     # All variants
make test-all      # Smoke tests
make scan          # Trivy scan
```

→ Full setup: **[Local Development](https://debugbox.ibtisam-iq.com/latest/development/local-setup/)**

---

## Full Documentation

**https://debugbox.ibtisam-iq.com**

- **[Variants](https://debugbox.ibtisam-iq.com/latest/variants/overview/)**
- **[Tooling Manifest](https://debugbox.ibtisam-iq.com/latest/reference/manifest/)**
- **[Examples](https://debugbox.ibtisam-iq.com/latest/guides/examples/)**
- **[Troubleshooting](https://debugbox.ibtisam-iq.com/latest/guides/troubleshooting/)**

---

## Troubleshooting & FAQ

Common issues and answers: **[Troubleshooting & FAQ](https://debugbox.ibtisam-iq.com/latest/guides/troubleshooting/)**

---

## Security

- Trivy scans block HIGH/CRITICAL vulnerabilities
- Deterministic builds with pinned tools

Report issues privately: **[SECURITY.md](SECURITY.md)**

---

## Contributing

Welcome! Please read **[CONTRIBUTING.md](CONTRIBUTING.md)**

---

## License

[MIT License](LICENSE)

---

Built by **[@ibtisam-iq](https://github.com/ibtisam-iq)**  
**Faster pulls. Faster debugging.**
