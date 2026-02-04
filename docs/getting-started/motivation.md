# Why DebugBox?

## The Problem

Modern production containers often ship **without basic debugging tools**. When something breaks:

```bash
kubectl exec -it my-pod -- curl
# curl: not found
```

Distroless, scratch, and minimal Alpine images are great for production — but they leave you blind when debugging.

## Existing Solutions

- **netshoot** (201.67 MB): Great tools, but overkill for a simple `curl` test
- **busybox** (1.5 MB): Tiny, but lacks real debugging tools
- **Alpine** (7.6 MB): Minimal but not debugging-focused

## The DebugBox Answer

**Three purpose-built variants** so you pull only what you need:

| Variant | Size | When to Use |
|---------|------|-------------|
| **lite** | ~14 MB | Quick network/DNS checks |
| **balanced** | ~46 MB | Daily Kubernetes troubleshooting (default) |
| **power** | ~104 MB | Deep forensics, packet capture |

**Result:** Up to **14× smaller** than netshoot for basic tasks. **4.3× faster pulls** for common cases.

## Comparison

| Feature | DebugBox | netshoot | busybox |
|---------|----------|----------|---------|
| Multiple size options | ✓ (3 variants) | ✗ | ✗ |
| Smallest option | 14 MB | 201 MB | 1.5 MB |
| Kubernetes-focused | ✓ (kubectx/kubens) | ✓ | ✗ |
| Multi-arch support | ✓ (amd64+arm64) | ✓ | ✓ |
| Pinned tool versions | ✓ | ✗ | ✗ |
| Security scanned (Trivy) | ✓ | ✗ | ✗ |

## Core Principles

- **Variants over bloat** — No unnecessary tools cluttering your images
- **Speed** — Faster incident response with minimal pull times
- **Transparency** — Every tool documented in the [manifest](../reference/manifest.md)
- **Debug-first** — Runs as root for full debugging access (ephemeral use only)

## Real-World Impact

### Bandwidth Savings
**Scenario: 50 pulls per week across your cluster**

| Container | Per Pull | 50 Pulls | Monthly |
|-----------|----------|----------|---------|
| netshoot | 201.67 MB | 10.08 GB | 40 GB |
| DebugBox lite | 14.36 MB | 718 MB | 2.8 GB |
| **Savings** | **187.31 MB** | **9.36 GB** | **37.2 GB** |

On bandwidth-constrained networks, this is **hours saved per month**.

### Speed Example
```
netshoot @ 100 Mbps:     0m16s (201.67 MB)
DebugBox lite @ 100 Mbps: 0m1s (14.36 MB)
```

→ Start with [Quick Start](quick-start.md) or [explore variants](../variants/overview.md)
