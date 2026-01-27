# DebugBox – Release Process

> **Audience:** Project maintainers, contributors, users  
> **Purpose:** Understand how DebugBox releases work, versioning guarantees, and image availability

## Overview

DebugBox follows a **strict, tag-based release model** for reproducibility and user safety.

### Release Flow

1. Push a version tag (`vX.Y.Z`)
2. GitHub Actions builds multi-arch images
3. Trivy security scan (blocks on HIGH/CRITICAL vulnerabilities)
4. Publish images to GHCR and Docker Hub
5. Create GitHub Release (manual step)

Users can pull versioned images immediately after publishing.

**Important:** Pushing to `main` does **not** create a release. Releases are intentional and triggered only by version tags:

```bash
git tag v1.0.0
git push origin v1.0.0
```

This automatically builds and publishes images for `linux/amd64` and `linux/arm64`.

## Versioning Scheme

DebugBox uses **Semantic Versioning** (`MAJOR.MINOR.PATCH`):

- `v1.0.0` – First stable release
- `v1.0.1` – Patch (bug fix, no breaking changes)
- `v1.1.0` – Minor (new features, backward compatible)
- `v2.0.0` – Major (breaking changes)

Pre-releases use identifiers:

- `v2.0.0-alpha.1`
- `v2.0.0-beta.1`
- `v2.0.0-rc.1`

### Key Versioning Rules

- Released versions are **immutable** – images never change after publishing
- Older versions remain available forever
- The `:latest` tag points only to the newest **stable** release (never pre-releases)

## Image Variants

| Variant      | Primary Tag Example        | Additional Tags        | Use Case                                                    | Tools Level    |
|--------------|----------------------------|------------------------|-------------------------------------------------------------|----------------|
| **Lite**     | `debugbox-lite`           | –                      | Minimal footprint, init containers, constrained environments | Basic          |
| **Balanced** | `debugbox` (default)      | `debugbox-balanced`    | Recommended for most users                                  | Standard       |
| **Power**    | `debugbox-power`          | –                      | Advanced SRE, forensics, production debugging               | Comprehensive  |
| **Base**     | `debugbox-base:latest`    | –                      | Foundation layer for custom variants (manual release)       | None           |

> **Note:** Base image is published manually (not part of automated release workflow).

All variants are published to both registries:

- **GHCR** (recommended): `ghcr.io/ibtisam-iq/<variant>`
- **Docker Hub**: `docker.io/mibtisam/<variant>`

Example tags for balanced variant:

```
ghcr.io/ibtisam-iq/debugbox:v1.0.0
ghcr.io/ibtisam-iq/debugbox:latest
docker.io/mibtisam/debugbox:v1.0.0
docker.io/mibtisam/debugbox:latest
```

Pulling without a tag defaults to the balanced variant and latest stable version:

```bash
docker pull ghcr.io/ibtisam-iq/debugbox   # → balanced, latest stable
```

## Multi-Architecture Support

All released images support **linux/amd64** and **linux/arm64**. Docker automatically selects the correct architecture – no extra flags needed.

```bash
# Works seamlessly on Intel, Apple Silicon, Graviton, etc.
docker pull ghcr.io/ibtisam-iq/debugbox:v1.0.0
```

## Common Usage Examples

```bash
# Latest stable (balanced)
docker pull ghcr.io/ibtisam-iq/debugbox
docker pull mibtisam/debugbox

# Specific version
docker pull ghcr.io/ibtisam-iq/debugbox:v1.0.0

# Lite variant
docker pull ghcr.io/ibtisam-iq/debugbox-lite:latest

# Power variant
docker pull ghcr.io/ibtisam-iq/debugbox-power:v1.0.0

# Interactive shell
docker run -it ghcr.io/ibtisam-iq/debugbox:latest
```

## Security Guarantees

Every released image provides:

- Traceability to a specific git tag
- Passed CI validation
- Scanned with Trivy (blocks release on HIGH/CRITICAL vulnerabilities)
- Immutability after publishing

If Trivy detects serious issues, the release fails and no images are published.

## Support Policy

| Version            | Status            | Support Duration | Security Patches       |
|--------------------|-------------------|------------------|------------------------|
| Current (e.g., v1.5.x) | Full support  | 12 months       | All severity levels    |
| Previous (N-1)     | Security-only     | 6 months        | HIGH/CRITICAL only     |
| Older (N-2+)       | Community support | Indefinite      | None guaranteed        |

In case of vulnerabilities or bugs, a new patch version is released promptly. Bad releases are never deleted – instead, a fixed version is published and the problematic one is marked in release notes.

### Handling Problematic Releases

We never delete or overwrite released images. If a vulnerability or critical bug is discovered:
- A patched version is released immediately
- The affected release is clearly marked in its GitHub Release notes with a warning
- Users pulling `:latest` automatically receive the fixed version

## Pre-Releases

Pre-release tags (alpha, beta, rc) follow the same build and publish process. Images are versioned accordingly, but `:latest` remains pointed at the newest stable release.

Support for pre-releases ends when the corresponding GA version is released.

## Making a New Release (Checklist)

### Before Release
- [ ] `main` branch CI is green
- [ ] Update CHANGELOG.md
- [ ] Choose appropriate version number

### Create Release
```bash
git tag -a v1.0.0 -m "Release v1.0.0: [brief description]"
git push origin v1.0.0
```

### Monitor
- Watch the "Release - Build & Publish DebugBox Images" workflow
- Confirm build, scan, and publish steps succeed

### After Release
- [ ] Verify images on GHCR and Docker Hub
- [ ] Create GitHub Release page manually:
  - Select the tag
  - Add release notes (features, fixes, breaking changes, etc.)
  - Publish

## Release History & Changelog

All releases, changelogs, and detailed notes are available at:  
[https://github.com/ibtisam-iq/debugbox/releases](https://github.com/ibtisam-iq/debugbox/releases)

## Questions or Suggestions

Open an issue: [https://github.com/ibtisam-iq/debugbox/issues](https://github.com/ibtisam-iq/debugbox/issues)

---

**Last Updated:** January 27, 2026  
**Maintained By:** DebugBox Core Team
