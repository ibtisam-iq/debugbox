# Image Tags & Registries

DebugBox images are published to two identical registries.

## Registries

| Registry              | Base Path                          | Recommended For          |
|-----------------------|------------------------------------|--------------------------|
| **GHCR** (primary)    | `ghcr.io/ibtisam-iq/`              | GitHub users, faster pulls |
| **Docker Hub** (mirror) | `docker.io/mibtisam/`            | Broad compatibility      |

Examples:
```bash
ghcr.io/ibtisam-iq/debugbox          # balanced
ghcr.io/ibtisam-iq/debugbox-lite
docker.io/mibtisam/debugbox-power
```

## Tags

- **Version tags**: `v1.0.0`, `v1.0.1`, `v1.1.0` (semantic versioning)
- **`:latest`**: Always points to newest stable release (not pre-releases)

## Default Variant

Unqualified names resolve to **balanced**:
```
ghcr.io/ibtisam-iq/debugbox == ghcr.io/ibtisam-iq/debugbox-balanced
ghcr.io/ibtisam-iq/debugbox:latest == ghcr.io/ibtisam-iq/debugbox-balanced:latest
```

## Recommendations

| Use Case              | Tag Recommendation                  |
|-----------------------|-------------------------------------|
| Development / testing | `:latest`                           |
| Production / CI/CD    | Pinned version (`:v1.0.0`)          |

→ **[Quick Start](../getting-started/quick-start.md)** | **[Release Process](https://github.com/ibtisam-iq/debugbox/blob/main/RELEASE.md)** →
