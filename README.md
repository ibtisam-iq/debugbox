# DebugBox

[![CI](https://github.com/ibtisam-iq/debugbox/actions/workflows/ci.yml/badge.svg)](https://github.com/ibtisam-iq/debugbox/actions/workflows/ci.yml)
[![Pages](https://github.com/ibtisam-iq/debugbox/actions/workflows/pages.yml/badge.svg)](https://github.com/ibtisam-iq/debugbox/actions/workflows/pages.yml)
[![Latest Release](https://img.shields.io/github/v/release/ibtisam-iq/debugbox?label=release)](https://github.com/ibtisam-iq/debugbox/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

[![Docker Pulls](https://img.shields.io/docker/pulls/mibtisam/debugbox?logo=docker&label=Docker%20Hub&logoColor=white)](https://hub.docker.com/r/mibtisam/debugbox)
[![GitHub Container Registry](https://img.shields.io/badge/GHCR-Available-brightgreen?logo=github&logoColor=white)](https://github.com/ibtisam-iq/debugbox/pkgs/container/debugbox)
[![Multi-Arch](https://img.shields.io/badge/Multi--Arch-amd64%20%7C%20arm64-blue?logo=docker&logoColor=white)](https://github.com/ibtisam-iq/debugbox)

**Docs:** https://debugbox.ibtisam-iq.com

---

## The Problem

You need to debug a pod. You run `kubectl debug my-pod --image=netshoot` and wait for **~202 MB** to download.

On an edge cluster? A metered connection? **Every MB costs time.**

And you just need to check DNS. You don't need tcpdump, tshark, routing tools. But netshoot is all-or-nothing.

---

## The Solution

**DebugBox** is a debugging container designed for Kubernetes. Pick the variant that fits your task.

Three sizes:

- **LITE** (~15 MB): DNS and connectivity
- **BALANCED** (~47 MB): Daily Kubernetes debugging
- **POWER** (~91 MB): Packet analysis and forensics

Includes `kubectx`/`kubens` (balanced+), `json()`/`yaml()` shell helpers, and pinned tool versions.

Not for persistent sidecars, production workloads, or control plane access. Runs as root, meant for ephemeral debugging only.

---

## Choosing Your Variant

```
                Need packet analysis or nmap?
                         │
                    ┌────┴─────┐
                    │          │
                   NO         YES ──────► POWER (~91 MB)
                    │                    (tshark, nmap, iptables)
                    │
           Need tcpdump, TLS, or K8s tools?
                    │
                ┌───┴────┐
                │        │
               NO       YES ─────────► BALANCED (~47 MB)
                │                     (tcpdump, openssl, kubectx/ns)
                │
                ▼
            LITE (~15 MB)
            (minimal, fast)
```

---

## Quick Start

### Kubernetes

```bash
# Debug a running pod (default: balanced variant)
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox

# Lite variant
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:lite

# Power variant
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:power

# Standalone debugging session
kubectl run debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never
```

### Docker

```bash
docker run -it ghcr.io/ibtisam-iq/debugbox         # balanced (default)
docker run -it ghcr.io/ibtisam-iq/debugbox:lite
docker run -it ghcr.io/ibtisam-iq/debugbox:power
```

---

## Size Comparison

| Image | Compressed Size |
|-------|-----------------|
| DebugBox lite | ~15 MB |
| DebugBox balanced | ~47 MB |
| DebugBox power | ~91 MB |
| netshoot v0.15 | ~202 MB |

DebugBox power is ~111 MB smaller than netshoot (55% reduction). DebugBox lite is ~13x smaller.

[Detailed bandwidth analysis](https://debugbox.ibtisam-iq.com/latest/guides/bandwidth-savings/)

---

## Features by Variant

**Source of truth:** [`docs/manifest.yaml`](https://github.com/ibtisam-iq/debugbox/blob/main/docs/manifest.yaml)

| Category | Tools | Lite | Balanced | Power |
|---|---|:---:|:---:|:---:|
| **Networking Basics** | curl, netcat, iproute2, iputils, bind-tools (dig, nslookup) | ✓ | ✓ | ✓ |
| **Data Parsing** | jq, yq | ✓ | ✓ | ✓ |
| **Shell** | bash, bash-completion, less | -- | ✓ | ✓ |
| **Editors** | vi / vim | vi | vim | vim |
| **TLS/SSL** | openssl | -- | ✓ | ✓ |
| **Filesystem** | git, file, tar, gzip | -- | ✓ | ✓ |
| **System** | htop, strace, lsof, procps, psmisc | -- | ✓ | ✓ |
| **System Deep** | ltrace | -- | -- | ✓ |
| **Networking** | tcpdump, socat, mtr | -- | ✓ | ✓ |
| **Network Scanning** | nmap, nmap-nping, nmap-scripts, iperf3, ethtool, iftop | -- | -- | ✓ |
| **Packet Analysis** | tshark, ngrep, tcptraceroute, fping | -- | -- | ✓ |
| **Routing** | iptables, nftables, conntrack-tools | -- | -- | ✓ |
| **Kubernetes** | kubectx, kubens | -- | ✓ | ✓ |
| **Helpers** | json(), yaml(), ll() | ✓ | ✓ | ✓ |
| **Network Helpers** | ports, connections, routes, k8s-info, sniff, sniff-http, sniff-dns, cert-check() | -- | ✓ | ✓ |
| **Forensics Helpers** | conntrack-watch | -- | -- | ✓ |

→ **[Detailed variant breakdown](https://debugbox.ibtisam-iq.com/latest/variants/overview/)**

---

## Comparison to Alternatives

| Feature | DebugBox | netshoot | busybox | Alpine |
|---------|----------|----------|---------|--------|
| **Smallest variant** | ~15 MB | ~202 MB | ~1.5 MB | ~7.6 MB |
| **Variants** | ✓ 3 sizes | ✗ one size | ✗ one size | ✗ one size |
| **Multi-arch** | ✓ amd64+arm64 | ✓ amd64+arm64 | ✓ amd64+arm64 | ✓ amd64+arm64 |
| **Pinned tools** | ✓ deterministic | ✗ floating | ✗ minimal | ✗ minimal |
| **Kubernetes helpers** | ✓ kubectx/ns | ✗ none | ✗ none | ✗ none |
| **Security scanned** | ✓ Trivy | ✗ manual | ✗ manual | ✗ manual |

---

## Image Tags

| Variant | Floating | Pinned |
|---------|----------|--------|
| lite | `debugbox:lite` | `debugbox:lite-X.Y.Z` |
| balanced (default) | `debugbox:latest` | `debugbox:X.Y.Z` |
| power | `debugbox:power` | `debugbox:power-X.Y.Z` |

Published to **GHCR** (`ghcr.io/ibtisam-iq/debugbox`) and **Docker Hub** (`docker.io/mibtisam/debugbox`). 22 tags per release.

For production, always pin versions. → **[Full tag reference](https://debugbox.ibtisam-iq.com/latest/reference/tags/)**

---

## Security

- Trivy scans block HIGH/CRITICAL on every release
- Alpine Linux base (minimal attack surface)

**[Security policy →](SECURITY.md)**

---

## FAQ

**Q: Can I use DebugBox in production?**

A: No. It runs as root and is designed for ephemeral debugging only.

**Q: Does DebugBox work on older Kubernetes versions?**

A: `kubectl run` works on any version. `kubectl debug` requires 1.23+.

**Q: What if I need a tool not in DebugBox?**

A: Extend it with your own Dockerfile or submit a feature request. See **[Local Development](https://debugbox.ibtisam-iq.com/latest/development/local-setup/)**.

→ **[More questions](https://debugbox.ibtisam-iq.com/latest/guides/troubleshooting/)**

---

## Documentation

**Full docs:** https://debugbox.ibtisam-iq.com

- [Kubernetes Usage](https://debugbox.ibtisam-iq.com/latest/usage/kubernetes/)
- [Docker Usage](https://debugbox.ibtisam-iq.com/latest/usage/docker/)
- [Variants Overview](https://debugbox.ibtisam-iq.com/latest/variants/overview/)
- [Common Workflows](https://debugbox.ibtisam-iq.com/latest/guides/examples/)
- [Local Development](https://debugbox.ibtisam-iq.com/latest/development/local-setup/)
- [Contributing](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)

---

## Local Development

```bash
git clone https://github.com/ibtisam-iq/debugbox.git
cd debugbox
make check    # lint, build, test, scan
```

See **[Local Development](https://debugbox.ibtisam-iq.com/latest/development/local-setup/)** for detailed setup.

---

[MIT License](LICENSE) | Built for Kubernetes debugging by [@ibtisam-iq](https://github.com/ibtisam-iq)
