# DebugBox

[![CI](https://github.com/ibtisam-iq/debugbox/actions/workflows/ci.yml/badge.svg)](https://github.com/ibtisam-iq/debugbox/actions/workflows/ci.yml)
[![Pages](https://github.com/ibtisam-iq/debugbox/actions/workflows/pages.yml/badge.svg)](https://github.com/ibtisam-iq/debugbox/actions/workflows/pages.yml)
[![Latest Release](https://img.shields.io/github/v/release/ibtisam-iq/debugbox?label=release)](https://github.com/ibtisam-iq/debugbox/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

[![Docker Pulls](https://img.shields.io/docker/pulls/mibtisam/debugbox?logo=docker&label=Docker%20Hub&logoColor=white)](https://hub.docker.com/r/mibtisam/debugbox)
[![GitHub Container Registry](https://img.shields.io/badge/GHCR-Available-brightgreen?logo=github&logoColor=white)](https://github.com/ibtisam-iq/debugbox/pkgs/container/debugbox)
[![Multi-Arch](https://img.shields.io/badge/Multi--Arch-amd64%20%7C%20arm64-blue?logo=docker&logoColor=white)](https://github.com/ibtisam-iq/debugbox)
[![Kubernetes Ready](https://img.shields.io/badge/Kubernetes-Ready-326ce5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)

**Docs:** https://debugbox.ibtisam-iq.com

---

## The Problem

You need to debug a pod. You run `kubectl debug my-pod --image=netshoot` and wait for **201 MB** to download.

On an edge cluster? Mobile network? Restricted bandwidth? **Every MB costs time.**

Worse still: you just need to check DNS. You don't need tcpdump, tshark, routing tools. But netshoot is all-or-nothing.

---

## The Solution

**DebugBox** is a Kubernetes-native debugging container that lets you choose exactly what you need.

- `kubectl debug` ephemeral containers, launch in seconds
- `kubectx`/`kubens` context switching built in
- Shell helpers pre-loaded: `json()` and `yaml()` functions ready to use
- Pinned tool versions for deterministic, repeatable builds

Three sizes:
- **LITE** (~15 MB): DNS and connectivity
- **BALANCED** (~51 MB): Daily Kubernetes debugging
- **POWER** (~112 MB): Packet analysis and forensics

---

## Choosing Your Variant

Pick the right size for your task:
```
                Need packet analysis or nmap?
                         │
                    ┌────┴─────┐
                    │          │
                   NO         YES ──────► POWER (~112 MB)
                    │                    (tshark, nmap, iptables)
                    │
           Need tcpdump, TLS, or K8s tools?
                    │
                ┌───┴────┐
                │        │
               NO       YES ─────────► BALANCED (~51 MB)
                │                     (tcpdump, openssl, kubectx/ns)
                │
               YES ────────────────► LITE (~15 MB)
                                    (minimal, fast)
```

---

## Quick Start

### Kubernetes (Recommended)

```bash
# Debug a running pod (default: balanced variant)
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox

# Use lite variant (minimal, fastest pull)
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:lite

# Use power variant (full forensics toolkit)
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:power

# Standalone debugging session
kubectl run debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never
```

### Docker

```bash
# Interactive session (latest balanced variant)
docker run -it ghcr.io/ibtisam-iq/debugbox

# Lite variant
docker run -it ghcr.io/ibtisam-iq/debugbox:lite

# Power variant
docker run -it ghcr.io/ibtisam-iq/debugbox:power
```

---

## Why DebugBox?

### Smaller Than netshoot

| Image | Compressed Size |
|-------|-----------------|
| DebugBox lite | ~15 MB |
| DebugBox balanced | ~51 MB |
| DebugBox power | ~112 MB |
| netshoot v0.15 | ~202 MB |

DebugBox power is ~90 MB smaller than netshoot (44% reduction).
DebugBox lite is ~13x smaller than netshoot.

On resource-constrained clusters (edge, IoT, Kubernetes on laptops), every MB counts. [See detailed bandwidth analysis](https://debugbox.ibtisam-iq.com/latest/guides/bandwidth-savings/)

### Secure by Default

- Trivy scans block HIGH/CRITICAL on every release
- Alpine Linux base (minimal attack surface)
- No unnecessary packages
- Multi-architecture support (amd64, arm64)

**[Security policy →](SECURITY.md)**

---

## Features by Variant

**What tools are included in each variant?** → **[Complete tool list](https://github.com/ibtisam-iq/debugbox/blob/main/docs/manifest.yaml)**

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
| **Network Helpers** | ports, connections, routes, k8s-info, sniff, cert-check() | -- | ✓ | ✓ |
| **Forensics Helpers** | conntrack-watch | -- | -- | ✓ |

**→ [Detailed variant breakdown](https://debugbox.ibtisam-iq.com/latest/variants/overview/)**

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

**Advantages:**
- Smaller when you need it (~15 MB vs ~202 MB)
- Larger when you need it (~112 MB for SRE workflows)
- Kubernetes-first design (kubectx/kubens built in)
- Predictable (pinned tools, repeatable builds)

---

## Use Cases

**Ephemeral debugging with `kubectl debug`:**
- ✅ One-off troubleshooting sessions
- ✅ Resource-constrained environments (edge, IoT, bandwidth-limited)
- ✅ Multi-cluster operations (kubectx/kubens included)
- ✅ Incident response (fast pull, ready to go)
- ✅ Learning Kubernetes networking
- ✅ SRE forensics workflows (power variant)

**Not for:**
- Persistent sidecars (use for ephemeral debugging only)
- Production workloads (runs as root, for debugging only)
- Kubernetes control plane access (no kubectl, no kube-proxy config)

---

## Image Tags & Registries

### Available Images

DebugBox is published to **two registries** with **20 tags per release**:

| Registry | URL |
|----------|-----|
| **GHCR (Recommended)** | `ghcr.io/ibtisam-iq/debugbox` |
| **Docker Hub** | `docker.io/mibtisam/debugbox` |

### Tag Strategy

All three variants are in **one repository** with **variant-based tags**:

#### **Primary Tags** (Variant Discovery)
```bash
debugbox:lite              # Latest lite variant
debugbox:balanced          # Latest balanced variant (default)
debugbox:power             # Latest power variant
```

#### **Floating Version Tags** (Latest per Variant)
```bash
debugbox:lite-latest       # Latest lite
debugbox:balanced-latest   # Latest balanced
debugbox:power-latest      # Latest power
```

#### **Pinned Version Tags** (Immutable, for Production)
```bash
debugbox:lite-1.0.0        # Lite v1.0.0
debugbox:balanced-1.0.0    # Balanced v1.0.0
debugbox:power-1.0.0       # Power v1.0.0
```

#### **Default Aliases** (Convenience)
```bash
debugbox:latest            # Alias to balanced-latest (default)
debugbox:1.0.0             # Alias to balanced-1.0.0 (short form)
```

**Production:** Always pin specific versions [See Image Tags](https://debugbox.ibtisam-iq.com/latest/reference/tags/)

---

## Documentation

**Full docs:** https://debugbox.ibtisam-iq.com

**Essential guides:**
- [Kubernetes Usage](https://debugbox.ibtisam-iq.com/latest/usage/kubernetes/): kubectl debug examples
- [Docker Usage](https://debugbox.ibtisam-iq.com/latest/usage/docker/): Docker run examples
- [Variants Overview](https://debugbox.ibtisam-iq.com/latest/variants/overview/): detailed tool breakdown
- [Image Tags & Registries](https://debugbox.ibtisam-iq.com/latest/reference/tags/): tagging strategy
- [Common Workflows](https://debugbox.ibtisam-iq.com/latest/guides/examples/): real debugging scenarios
- [Local Development](https://debugbox.ibtisam-iq.com/latest/development/local-setup/): build and test locally
- [Contributing](CONTRIBUTING.md): how to contribute

---

## FAQ

**Q: Can I use DebugBox in production?**
A: No. DebugBox runs as root and is designed for ephemeral debugging containers only. Use `kubectl debug` or temporary pods.

**Q: What if I need a tool not in DebugBox?**
A: You can extend DebugBox by creating your own Dockerfile or submitting a feature request. See **[Local Development](https://debugbox.ibtisam-iq.com/latest/development/local-setup/)**.

**Q: How do I pin a specific version in production?**
A: Use the full tag: `ghcr.io/ibtisam-iq/debugbox:1.0.0` (balanced) or `ghcr.io/ibtisam-iq/debugbox:lite-1.0.0` (lite). See **[Image Tags](https://debugbox.ibtisam-iq.com/latest/reference/tags/)** for full strategy.

**Q: Does DebugBox work on Kubernetes 1.18+?**
A: Yes, works on Kubernetes 1.18+. Best experience with 1.20+ (has `kubectl debug` support).

**Q: Can I use DebugBox outside Kubernetes?**
A: Yes. `docker run -it ghcr.io/ibtisam-iq/debugbox` works for local debugging.

**More questions?** → **[Full Troubleshooting Guide](https://debugbox.ibtisam-iq.com/latest/guides/troubleshooting/)**

---

## Local Development

```bash
git clone https://github.com/ibtisam-iq/debugbox.git
cd debugbox

make build-all     # All variants
make test-all      # Smoke tests
make scan          # Trivy scan
```

See **[Local Development](https://debugbox.ibtisam-iq.com/latest/development/local-setup/)** for detailed setup.

---

## Contributing

Found a bug? Have an idea? We welcome contributions!

→ **[Contributing Guidelines](CONTRIBUTING.md)**

---

## License

[MIT License](LICENSE)

---

## Changelog

**v1.0.0** (Feb 2026)
- Public release
- 3 variants: lite, balanced, power
- Multi-arch support (amd64, arm64)
- Kubernetes-optimized with kubectx/kubens
- SRE-grade routing and analysis tools in power variant

→ **[Full changelog](CHANGELOG.md)**

---

## Support & Community

- **GitHub Discussions**: ask questions, share ideas
- **GitHub Issues**: report bugs or request features
- **Documentation**: https://debugbox.ibtisam-iq.com
- **Code of Conduct**: [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)

---

Built for Kubernetes debugging by [@ibtisam-iq](https://github.com/ibtisam-iq)
