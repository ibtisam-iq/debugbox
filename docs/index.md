# DebugBox

**A lightweight, variant-based debugging container suite**
for Kubernetes and Docker environments.

[![Docker Pulls](https://img.shields.io/docker/pulls/mibtisam/debugbox?logo=docker&label=Docker%20Hub&logoColor=white)](https://hub.docker.com/r/mibtisam/debugbox)
[![GitHub Container Registry](https://img.shields.io/badge/GHCR-Available-brightgreen?logo=github&logoColor=white)](https://github.com/ibtisam-iq/debugbox/pkgs/container/debugbox)
[![Multi-Arch](https://img.shields.io/badge/Multi--Arch-amd64%20%7C%20arm64-blue?logo=docker&logoColor=white)](https://github.com/ibtisam-iq/debugbox)

[![Trivy Scanning](https://img.shields.io/badge/Security-Trivy%20Scanned-blue?logo=aqua&logoColor=white)](https://github.com/aquasecurity/trivy)
[![Powered by Alpine](https://img.shields.io/badge/Powered%20by-Alpine%20Linux-0D597F?logo=alpine-linux&logoColor=white)](https://alpinelinux.org/)
[![Kubernetes Ready](https://img.shields.io/badge/Kubernetes-Ready-326ce5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)

Choose exactly the right size for your debugging task — no bloat, no waiting.

| Variant | Size | Best For | Image |
|---------|------|----------|-------|
| **lite** | ~14 MB | Network/DNS checks | `ghcr.io/ibtisam-iq/debugbox:lite` |
| **balanced** (default) | ~46 MB | Daily Kubernetes troubleshooting | `ghcr.io/ibtisam-iq/debugbox` |
| **power** | ~104 MB | Packet capture & deep forensics | `ghcr.io/ibtisam-iq/debugbox:power` |

Also available on Docker Hub: `mibtisam/debugbox:*`

Supports **amd64** and **arm64** (Apple Silicon, Graviton, Raspberry Pi) out of the box.

---

## Quick Start

Debug a running pod in seconds:

```bash
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox
```

Or launch a standalone session:

```bash
kubectl run debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never
```

Now you're inside with curl, dig, tcpdump, vim, strace, and more.

→ **[Full quick start guide](getting-started/quick-start.md)** | **[Installation](getting-started/installation.md)**

---

## Why DebugBox?

Modern pods often lack basic debugging tools. DebugBox gives you **three focused variants** so you only pull what you need.

> 14 MB for basic connectivity · 46 MB for daily debugging · 104 MB only when you need advanced forensics

**Faster pulls. Faster debugging.**

→ **[See the full motivation](getting-started/motivation.md)**

---

## Explore the Docs

<div class="grid cards" markdown>

- **[:material-run-fast: Getting Started](getting-started/quick-start.md)**
  First steps, installation, motivation

- **[:material-layers: Variants](variants/overview.md)**
  Compare lite · balanced · power and choose the right one

- **[:material-kubernetes: Kubernetes Usage](usage/kubernetes.md)**
  `kubectl debug`, ephemeral containers, sidecar patterns

- **[:material-docker: Docker Usage](usage/docker.md)**
  Network namespace sharing, host inspection

- **[:material-tools: Tooling Manifest](reference/manifest.md)**
  Complete list of included tools per variant

- **[:material-book-open-page-variant: Examples](guides/examples.md)**
  Real-world debugging scenarios

- **[:material-shield-check: Security](security/policy.md)**
  Reporting, scanning, design trade-offs

- **[:material-console-line: Development](development/local-setup.md)**
  Build, test and scan locally

</div>

---

**Ready to debug faster?**

Start with [Quick Start](getting-started/quick-start.md) or [choose your variant](variants/overview.md).

Built with ❤️ by [@ibtisam-iq](https://github.com/ibtisam-iq) · [MIT License](https://github.com/ibtisam-iq/debugbox/blob/main/LICENSE)
