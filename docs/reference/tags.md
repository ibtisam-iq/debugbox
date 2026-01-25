# Image Tags & Registries

DebugBox publishes images to two registries with identical content.

## Registries

### GitHub Container Registry (Primary)

Recommended for faster pulls and better GitHub integration.

```
ghcr.io/ibtisam-iq/debugbox-lite
ghcr.io/ibtisam-iq/debugbox-balanced
ghcr.io/ibtisam-iq/debugbox-power
```

### Docker Hub (Mirror)

Alternative registry with identical content.

```
docker.io/mibtisam/debugbox-lite
docker.io/mibtisam/debugbox-balanced
docker.io/mibtisam/debugbox-power
```

---

## Tagging Strategy

### Version Tags

Each release is tagged with semantic versioning:

```
v1.0.0    # Major.Minor.Patch
v1.0.1
v1.1.0
v2.0.0
```

### Latest Tag

The `latest` tag always points to the most recent stable release:

```bash
ghcr.io/ibtisam-iq/debugbox:latest        # Points to v1.2.3
ghcr.io/ibtisam-iq/debugbox-lite:latest   # Points to v1.2.3
ghcr.io/ibtisam-iq/debugbox-power:latest  # Points to v1.2.3
```

---

## Default Variant

The unqualified image name points to **balanced**:

```
ghcr.io/ibtisam-iq/debugbox           == ghcr.io/ibtisam-iq/debugbox-balanced
ghcr.io/ibtisam-iq/debugbox:v1.0.1   == ghcr.io/ibtisam-iq/debugbox-balanced:v1.0.1
ghcr.io/ibtisam-iq/debugbox:latest   == ghcr.io/ibtisam-iq/debugbox-balanced:latest
```

---

## Pull Examples

### Pinned Version (Production)

```bash
docker pull ghcr.io/ibtisam-iq/debugbox:{{ git.tag or git.describe }}
kubectl ... --image=ghcr.io/ibtisam-iq/debugbox:{{ git.tag or git.describe }}
```

### Latest Stable

```bash
docker pull ghcr.io/ibtisam-iq/debugbox:latest
kubectl ... --image=ghcr.io/ibtisam-iq/debugbox:latest
```

### Specific Variant

```bash
docker pull ghcr.io/ibtisam-iq/debugbox-lite:latest
docker pull ghcr.io/ibtisam-iq/debugbox-power:{{ git.tag or git.describe }}
```

### From Docker Hub

```bash
docker pull mibtisam/debugbox:latest
docker pull mibtisam/debugbox-power:{{ git.tag or git.describe }}
```

---

## Recommendation

- **Development/testing:** Use `latest`
- **Production:** Use pinned version (e.g., `{{ git.tag or git.describe }}`)
- **CI/CD pipelines:** Use pinned version for reproducibility
