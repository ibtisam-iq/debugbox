# Image Tags & Registries

DebugBox is published to **two identical registries** with **20 tags per release** using a single-repository variant strategy.

## Registries

| Registry | URL | Primary? |
|----------|-----|----------|
| **GitHub Container Registry (GHCR)** | `ghcr.io/ibtisam-iq/debugbox` | Yes (recommended) |
| **Docker Hub** | `docker.io/mibtisam/debugbox` | Mirror |

## Tag Strategy

All three variants in **one repository** with **variant-based tagging**:

### Primary Tags (Variant Discovery)

```bash
ghcr.io/ibtisam-iq/debugbox:lite         # Latest lite
ghcr.io/ibtisam-iq/debugbox:balanced     # Latest balanced
ghcr.io/ibtisam-iq/debugbox:power        # Latest power
```

### Floating Version Tags (Latest per Variant)

```bash
ghcr.io/ibtisam-iq/debugbox:lite-latest
ghcr.io/ibtisam-iq/debugbox:balanced-latest
ghcr.io/ibtisam-iq/debugbox:power-latest
```

### Pinned Version Tags (Production)

```bash
ghcr.io/ibtisam-iq/debugbox:lite-1.0.0         # Immutable
ghcr.io/ibtisam-iq/debugbox:balanced-1.0.0
ghcr.io/ibtisam-iq/debugbox:power-1.0.0
```

### Default Aliases (Convenience, Balanced Only)

```bash
ghcr.io/ibtisam-iq/debugbox:latest     # Alias to balanced-latest
ghcr.io/ibtisam-iq/debugbox:1.0.0      # Alias to balanced-1.0.0
```

## Quick Reference

| Use Case | Example |
|----------|---------|
| Development (latest balanced) | `ghcr.io/ibtisam-iq/debugbox` |
| Latest lite | `ghcr.io/ibtisam-iq/debugbox:lite` |
| Latest power | `ghcr.io/ibtisam-iq/debugbox:power` |
| Production (balanced) | `ghcr.io/ibtisam-iq/debugbox:1.0.0` |
| Production (lite) | `ghcr.io/ibtisam-iq/debugbox:lite-1.0.0` |
| Production (power) | `ghcr.io/ibtisam-iq/debugbox:power-1.0.0` |

## Best Practices

**Development:**

- Use `:latest` or variant name for interactive debugging
- Example: `docker run -it ghcr.io/ibtisam-iq/debugbox:lite`

**Production & CI/CD:**

- **Always pin specific version and variant**
- Never use `:latest` in production manifests
- Example: `ghcr.io/ibtisam-iq/debugbox:balanced-1.0.0`

## Versioning

DebugBox follows **Semantic Versioning** (MAJOR.MINOR.PATCH):

- `v1.0.0` — First stable release
- `v1.0.1` — Patch (bug fix)
- `v1.1.0` — Minor (features, backward compatible)
- `v2.0.0` — Major (breaking changes)

**Key Rules:**

- Released versions are immutable
- Older versions remain available forever
- `:latest` always points to newest stable (never pre-releases)

## Total Tags Per Release

| Category | Pattern | Count |
|----------|---------|-------|
| Primary discovery | `:lite`, `:balanced`, `:power` | 3 |
| Floating version | `:-latest` (3 variants) | 3 |
| Pinned version | `:-1.0.0` (3 variants) | 3 |
| Default aliases | `:latest`, `:1.0.0` | 2 |
| **Per registry** | — | **11 tags** |
| **Both registries** | GHCR + Docker Hub | **20 tags** |

→ **[Installation](../getting-started/installation.md)** | **[Variants Overview](../variants/overview.md)** | **[Quick Start](../getting-started/quick-start.md)**
