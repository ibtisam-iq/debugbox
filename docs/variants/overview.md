# Variants Overview

DebugBox provides **three purpose-built variants** optimized for different use cases.

| Variant | Size | Use When | Image |
|---------|------|----------|-------|
| **lite** | ~14 MB | Quick network/DNS checks | `ghcr.io/ibtisam-iq/debugbox:lite` |
| **balanced** (default) | ~46 MB | Daily Kubernetes troubleshooting | `ghcr.io/ibtisam-iq/debugbox` |
| **power** | ~104 MB | Deep forensics, packet capture | `ghcr.io/ibtisam-iq/debugbox:power` |

## Choosing Your Variant

- **Lite:** For bandwidth constraints, init containers, edge devices. Limited to basic connectivity tools.
- **Balanced:** Daily driver (recommended). TCP dump, system inspection, Kubernetes helpers included.
- **Power:** When you need advanced forensics — packet analysis, routing, library tracing, Python scripting.

## Detailed Pages

- **[Lite](lite.md)** — Minimal (14 MB)
- **[Balanced](balanced.md)** — Recommended (46 MB)
- **[Power](power.md)** — Comprehensive (104 MB)

## Pulling Latest vs. Specific Version

**Latest (for development):**
```bash
docker pull ghcr.io/ibtisam-iq/debugbox:lite        # Latest lite
docker pull ghcr.io/ibtisam-iq/debugbox             # Latest balanced
docker pull ghcr.io/ibtisam-iq/debugbox:power       # Latest power
```

**Specific version (for production):**
```bash
docker pull ghcr.io/ibtisam-iq/debugbox:lite-1.0.0
docker pull ghcr.io/ibtisam-iq/debugbox:1.0.0
docker pull ghcr.io/ibtisam-iq/debugbox:power-1.0.0
```

→ **[Complete tag reference](../reference/tags.md)**

## Inheritance Model

All variants build on each other:

- **Lite** — Base networking tools
- **Balanced** — Lite + system inspection + Kubernetes helpers
- **Power** — Balanced + packet analysis + advanced routing + scripting

Every tool in lite is also in balanced and power.

→ **[Complete tool list](../reference/manifest.md)**
