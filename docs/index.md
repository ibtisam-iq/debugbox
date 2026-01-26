# DebugBox

**A lightweight, variant-based debugging container suite**  
for Kubernetes and Docker environments.

Pull **only what you need** — from 15 MB quick checks to 110 MB full forensics.

| Variant       | Size      | Best For                              | Pull Command                                      |
|---------------|-----------|---------------------------------------|---------------------------------------------------|
| **lite**      | ~15 MB   | Network/DNS checks                    | `ghcr.io/ibtisam-iq/debugbox-lite`               |
| **balanced** (default) | ~48 MB   | Daily Kubernetes troubleshooting      | `ghcr.io/ibtisam-iq/debugbox`                    |
| **power**     | ~110 MB  | Packet capture & deep forensics        | `ghcr.io/ibtisam-iq/debugbox-power`              |

Also available on Docker Hub: `mibtisam/debugbox*`

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

Now you're inside with `curl`, `dig`, `tcpdump`, `vim`, `strace`, and more.

→ **[Full quick start guide](getting-started/quick-start.md)**

---

## Why DebugBox?

Modern pods often lack basic tools:

```bash
kubectl exec -it my-pod -- curl
# curl: not found
```

Alternatives like `netshoot` are great but **208 MB** — too heavy for simple checks.

DebugBox gives you **three focused variants** so you pull:

- **15 MB** for basic connectivity
- **48 MB** for daily debugging
- **110 MB** only when you need `tshark` or `nftables`

**Faster pulls. Faster debugging.**

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
  Real-world debugging recipes

- **[:material-shield-check: Security](security/policy.md)**  
  Reporting, scanning, design trade-offs

- **[:material-code-brackets: Development](development/local-setup.md)**  
  Build, test locally

</div>

---

## Features

- **Multi-architecture** – Seamless on x86, ARM, Apple Silicon
- **Deterministic builds** – Critical tools pinned with SHA verification
- **Security scanned** – Trivy blocks HIGH/CRITICAL on every release
- **Runs as root** – By design, for full debugging access (ephemeral use only)

---

**Ready to debug faster?**
  
Start with the [Quick Start](getting-started/quick-start.md) or [choose your variant](variants/overview.md).

Built and maintained by [@ibtisam-iq](https://github.com/ibtisam-iq) · [MIT License](https://github.com/ibtisam-iq/debugbox/blob/main/LICENSE)
