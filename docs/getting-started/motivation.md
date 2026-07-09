# Why DebugBox?

## The Problem

Modern production containers often ship **without basic debugging tools**. When something breaks:

```bash
kubectl exec -it my-pod -- curl
# curl: not found
```

Distroless, scratch, and minimal Alpine images are good for production, but they leave you blind when debugging.

## Existing Solutions

- **netshoot** (~202 MB): Good tools, but overkill for a simple `curl` test
- **busybox** (1.5 MB): Tiny, but lacks real debugging tools
- **Alpine** (7.6 MB): Minimal but not debugging-focused

## The DebugBox Answer

**Three purpose-built variants** so you pull only what you need:

| Variant | Size | When to Use |
|---------|------|-------------|
| **lite** | ~15 MB | Quick network/DNS checks |
| **balanced** | ~47 MB | Daily Kubernetes troubleshooting (default) |
| **power** | ~91 MB | Deep forensics, packet capture |

Up to ~13x smaller than netshoot for basic tasks.

## Comparison

| Feature | DebugBox | netshoot | busybox |
|---------|----------|----------|---------|
| Multiple size options | ✓ (3 variants) | ✗ | ✗ |
| Smallest option | ~15 MB | ~202 MB | ~1.5 MB |
| Kubernetes-focused | ✓ (kubectx/kubens) | ✓ | ✗ |
| Multi-arch support | ✓ (amd64+arm64) | ✓ | ✓ |
| Pinned tool versions | ✓ | ✗ | ✗ |
| Security scanned (Trivy) | ✓ | ✗ | ✗ |

## Core Principles

- **Variants over bloat**: no unnecessary tools in your images
- **Speed**: faster incident response with minimal pull times
- **Transparency**: every tool documented in the [manifest](../reference/manifest.md)
- **Debug-first**: runs as root for full debugging access (ephemeral use only)

For detailed bandwidth analysis with real-world scenarios and cost projections, see **[Bandwidth Savings](../guides/bandwidth-savings.md)**.

→ Start with [Quick Start](quick-start.md) or [explore variants](../variants/overview.md)
