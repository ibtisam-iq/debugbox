# Variants Overview

DebugBox provides **three purpose-built variants** so you pull only what you need.

| Variant    | Size     | Best For                                      | Pull Command                              |
|------------|----------|-----------------------------------------------|-------------------------------------------|
| **lite**   | ~15 MB  | Quick network/DNS checks                      | `ghcr.io/ibtisam-iq/debugbox-lite`       |
| **balanced** (default) | ~48 MB  | Daily Kubernetes troubleshooting             | `ghcr.io/ibtisam-iq/debugbox`            |
| **power**  | ~110 MB | Deep forensics & packet analysis              | `ghcr.io/ibtisam-iq/debugbox-power`      |

**Recommendation:** Start with **balanced** — it's the default and covers 90% of use cases.

## Choosing the Right Variant

- Use **lite** when pull speed is critical (e.g., incident response, constrained bandwidth)
- Use **balanced** for general debugging (recommended default)
- Use **power** only when you need advanced tools like `tshark`, `nftables`, or `ltrace`

## Detailed Pages

- **[Lite Variant →](lite.md)** — Minimal & fast
- **[Balanced Variant →](balanced.md)** — Recommended daily driver
- **[Power Variant →](power.md)** — Full SRE toolkit

→ Complete tool list: **[Tooling Manifest](../reference/manifest.md)**