# Why DebugBox?

## The Pain Point

You've probably seen this:

```bash
kubectl exec -it my-pod -- curl
# exec failed: "curl": executable file not found
```

Modern production containers (distroless, scratch, minimal Alpine) ship **without basic debugging tools**.

Existing solutions help, but:

- `netshoot`: Great tools, but **208 MB** — overkill for a simple `curl`
- `busybox`: Tiny (1.5 MB), but lacks real debugging tools

## The DebugBox Solution

**Three purpose-built variants** so you pull only what you need:

| Variant    | Size    | When to Use                              |
|------------|---------|------------------------------------------|
| lite       | ~15 MB | Quick network/DNS checks                 |
| balanced   | ~48 MB | Daily Kubernetes troubleshooting (default) |
| power      | ~110 MB| Deep forensics, packet capture           |

**Result:** Up to **4.3× faster pulls** than alternatives for common cases.

## Comparison

| Feature                | DebugBox     | netshoot    | busybox   |
|------------------------|--------------|-------------|-----------|
| Multiple size options  | ✓ (3 variants) | ✗           | ✗         |
| Smallest option        | 15 MB        | 208 MB      | 1.5 MB    |
| Kubernetes-focused     | ✓            | ✓           | ✗         |
| Multi-arch support     | ✓            | ✓           | ✓         |
| Deterministic builds   | ✓            | ✗           | ✗         |
| Security scanned       | ✓ (Trivy)    | ✗           | ✗         |

## Core Principles

- **Variants over bloat** – No unnecessary tools
- **Speed** – Faster incident response
- **Transparency** – Everything documented in the **[tool manifest](../reference/manifest.md)**
- **Debug-first** – Runs as root for full access (ephemeral use only)

→ Back to **[Quick Start](quick-start.md)** | Explore **[Variants](../variants/overview.md)**
