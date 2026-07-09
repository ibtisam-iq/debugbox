# Variants Overview

DebugBox provides **three purpose-built variants** optimized for different use cases.

| Variant | Size | Use When | Image |
|---------|------|----------|-------|
| **lite** | ~15 MB | Quick network/DNS checks | `ghcr.io/ibtisam-iq/debugbox:lite` |
| **balanced** (default) | ~47 MB | Daily Kubernetes troubleshooting | `ghcr.io/ibtisam-iq/debugbox` |
| **power** | ~91 MB | Deep forensics, packet capture | `ghcr.io/ibtisam-iq/debugbox:power` |

## Choosing Your Variant

- **Lite:** For bandwidth constraints, init containers, edge devices. Limited to basic connectivity tools.
- **Balanced:** Daily driver (recommended). TCP dump, TLS inspection, system debugging, Kubernetes helpers included.
- **Power:** When you need advanced forensics: deep packet analysis, port scanning, routing inspection, library tracing.

## Detailed Pages

- **[Lite](lite.md)** -- Minimal (~15 MB)
- **[Balanced](balanced.md)** -- Recommended (~47 MB)
- **[Power](power.md)** -- Comprehensive (~91 MB)

## Inheritance Model

Each higher variant includes all tools from the lower variants:

- **Lite** -- Base networking tools
- **Balanced** -- Everything in lite + TLS + system inspection + Kubernetes helpers
- **Power** -- Everything in balanced + deep packet analysis + port scanning + routing

Every tool in lite is also in balanced and power.

→ **[Complete Tool List](../reference/manifest.md)**
