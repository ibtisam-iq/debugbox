# DebugBox – Release Process

> **Audience:** Project maintainers, contributors, users
> **Purpose:** Understand how DebugBox releases work, versioning guarantees, and image availability

## Overview

DebugBox follows a **strict, tag-based release model** for reproducibility and user safety.

### Release Flow

1. Push a version tag (`vX.Y.Z`)
2. GitHub Actions builds multi-arch images (amd64, arm64)
3. Trivy security scan validates all variants (blocks on HIGH/CRITICAL vulnerabilities)
4. Publish images to GHCR and Docker Hub (if all scans pass)
5. Create GitHub Release (manual step for full control)

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

## Image Variants & Tagging

DebugBox publishes a **single repository** with **three variants**, each discoverable by name and available in multiple tag formats.

### Variant Overview

| Variant | Primary Tag | Description | Use Case | Tools Level |
|---------|------------|-------------|----------|-------------|
| **Lite** | `debugbox:lite` | Minimal footprint, essential tools only | Init containers, constrained environments, edge devices | Basic |
| **Balanced** | `debugbox:balanced` | Recommended for most users | Default choice, development, CI/CD, general debugging | Standard |
| **Power** | `debugbox:power` | Comprehensive toolkit | Advanced SRE, forensics, production incident response | Comprehensive |

### Tag Patterns

For each release version (e.g., `v1.0.0`), all three variants are published with consistent tag patterns:

#### **Primary Tags (Variant Discovery)**
These are the easiest way to pull a variant – users just remember the variant name:

```
ghcr.io/ibtisam-iq/debugbox:lite
ghcr.io/ibtisam-iq/debugbox:balanced
ghcr.io/ibtisam-iq/debugbox:power
```

#### **Latest Variant Tags (Floating per Variant)**
These point to the latest release of each variant:

```
ghcr.io/ibtisam-iq/debugbox:lite-latest
ghcr.io/ibtisam-iq/debugbox:balanced-latest
ghcr.io/ibtisam-iq/debugbox:power-latest
```

#### **Pinned Version + Variant Tags (Production)**
These are for production deployments – specific version + specific variant, never changes:

```
ghcr.io/ibtisam-iq/debugbox:lite-1.0.0
ghcr.io/ibtisam-iq/debugbox:balanced-1.0.0
ghcr.io/ibtisam-iq/debugbox:power-1.0.0
```

#### **Default Aliases (Balanced)**
These convenience aliases point to the balanced variant (recommended default):

```
ghcr.io/ibtisam-iq/debugbox:latest       ← Points to balanced-latest
ghcr.io/ibtisam-iq/debugbox:1.0.0        ← Points to balanced-1.0.0 (shorter form)
```

### Complete Tag List for v1.0.0

| Variant                        | Primary                  | Floating                     | Pinned                          |
|--------------------------------|--------------------------|------------------------------|---------------------------------|
| **Lite**                       | `debugbox:lite`          | `debugbox:lite-latest`       | `debugbox:lite-1.0.0`           |
| **Balanced**                   | `debugbox:balanced`      | `debugbox:balanced-latest`   | `debugbox:balanced-1.0.0`       |
| **Power**                      | `debugbox:power`         | `debugbox:power-latest`      | `debugbox:power-1.0.0`          |
| **Default** (aliases → balanced) | `debugbox:latest`      | –                            | `debugbox:1.0.0`                |

**Published to both registries:**
- **GHCR** (recommended): `ghcr.io/ibtisam-iq/debugbox`
- **Docker Hub** (mirror): `docker.io/mibtisam/debugbox`

**Total tags per release:** 20 tags (10 unique patterns × 2 registries)

**Real images:** 3 (one per variant)  
**Aliases/Floating tags:** 8 (all pointing to one of the 3 real images)

**Note:** The **Default** row shows convenience aliases (`:latest` and `:1.0.0`) that always point to the **balanced** variant — the recommended default for most users.

**Quick tip:** For production, always use pinned tags (`:lite-1.0.0`, `:balanced-1.0.0`, `:1.0.0`, etc.) or digests (`@sha256:...`) to avoid surprises from floating tags.


## Common Usage Examples

### Quick Start (Recommended)

```bash
# Latest balanced (default) – shortest & most common
docker pull ghcr.io/ibtisam-iq/debugbox
docker run -it ghcr.io/ibtisam-iq/debugbox

# Or explicit latest
docker pull ghcr.io/ibtisam-iq/debugbox:latest
```

### By Variant (Latest)

```bash
docker pull ghcr.io/ibtisam-iq/debugbox:lite
docker pull ghcr.io/ibtisam-iq/debugbox:balanced      # same as default
docker pull ghcr.io/ibtisam-iq/debugbox:power
```

### By Version (Exact / Production-safe)

```bash
# Short form – pulls balanced@1.0.0
docker pull ghcr.io/ibtisam-iq/debugbox:1.0.0

# Explicit variant + version
docker pull ghcr.io/ibtisam-iq/debugbox:lite-1.0.0
docker pull ghcr.io/ibtisam-iq/debugbox:balanced-1.0.0
docker pull ghcr.io/ibtisam-iq/debugbox:power-1.0.0
```

### Docker Hub Mirror

```bash
# Same tags, different registry
docker pull mibtisam/debugbox:1.0.0
docker pull mibtisam/debugbox:lite
docker pull mibtisam/debugbox:latest
```

For Docker Compose or Kubernetes usage examples, see the [README.md](README.md).

## Multi-Architecture Support

All released images support **linux/amd64** and **linux/arm64**. Docker automatically selects the correct architecture – no extra flags needed.

```bash
# Same pull command works seamlessly on Intel, Apple Silicon, Graviton, etc.
docker pull ghcr.io/ibtisam-iq/debugbox:1.0.0
docker pull ghcr.io/ibtisam-iq/debugbox:lite-1.0.0

# Works identically on x86_64, ARM64, Apple Silicon, AWS Graviton
docker run -it ghcr.io/ibtisam-iq/debugbox:1.0.0
```

## Variant Selection Guide

Use this table to choose which variant to pull:

| Question | Answer | Recommendation |
|----------|--------|-----------------|
| Are you new to DebugBox? | Yes | **Pull `debugbox` or `debugbox:balanced`** (default) |
| Do you need all tools and features? | Yes | **Pull `debugbox:power`** |
| Do you have strict resource constraints? | Yes | **Pull `debugbox:lite`** |
| Are you using in Kubernetes init containers? | Yes | **Pull `debugbox:lite`** (minimal layer) |
| Are you building custom images on top? | Yes | **Pull `debugbox:lite`** (smaller base) |
| Are you doing advanced SRE/incident response? | Yes | **Pull `debugbox:power`** |
| Should I use `:latest` or pin a version? | Production | **Always pin:** `debugbox:1.0.0` or `debugbox:balanced-1.0.0` |
| Can I use floating tags in production? | Generally no | **Use pinned:** `debugbox:power-1.0.0` |
| Do I need different variants per environment? | Yes | **Lite** (dev/test), **Power** (prod SRE) |

## Security Guarantees

Every released image provides:

- **Traceability** – Linked to specific git tag (e.g., `v1.0.0`)
- **CI validation** – Passed all build checks
- **Multi-arch integrity** – Both amd64 and arm64 validated
- **Vulnerability scanning** – Trivy scan (HIGH/CRITICAL blocks release)
- **Immutability** – Images never change after publishing

### Scan Policy

Before any image is published, all three variants (lite, balanced, power) must pass Trivy scanning with no HIGH or CRITICAL vulnerabilities.

**If any variant fails scan:**
- Entire release is blocked (no images published)
- No partial release state
- Maintainer fixes the issue and re-runs the workflow
- Re-tagging the same git tag retries the build

**Why amd64-only scan?**
- 99% of vulnerabilities are in shared base layers (OS packages, dependencies)
- amd64 and arm64 have identical software stacks (different CPU instruction sets only)
- Scanning both would double build time (~30 min) with negligible additional benefit
- **Industry standard** – Docker Official Images, Python, Node, Redis all scan one platform

## Support Policy

| Version | Status | Duration | Support Level |
|---------|--------|----------|---------------|
| Current (e.g., v1.5.x) | Full support | 12 months | All severity levels |
| Previous (N-1) | Security-only | 6 months | HIGH/CRITICAL only |
| Older (N-2+) | Community | Indefinite | Community-driven |

### Handling Vulnerabilities

We never delete or overwrite released images. If a vulnerability or critical bug is discovered:

1. A patched version is released immediately (e.g., `v1.0.0` → `v1.0.1`)
2. The affected release is clearly marked in GitHub Release notes with a warning
3. Users pulling `:latest` or `:balanced-latest` automatically receive the fixed version
4. Users on older versions can upgrade at their discretion
5. Old images remain available for reference or historical testing

## Pre-Releases

Pre-release tags (alpha, beta, rc) follow the same build and publish process. Images are versioned and tagged accordingly, but `:latest` remains pointed at the newest stable release.

Example pre-release tags:

```
debugbox:lite-2.0.0-rc.1
debugbox:balanced-2.0.0-rc.1
debugbox:power-2.0.0-rc.1

debugbox:lite                  ← Still points to v1.5.0 (stable)
debugbox:balanced              ← Still points to v1.5.0 (stable)
debugbox:power                 ← Still points to v1.5.0 (stable)
debugbox:latest                ← Still points to v1.5.0 (stable)
```

Support for pre-releases ends when the corresponding GA version is released.

## Release Workflow (Technical Details)

### Automated Build Process

1. **Trigger:** Git tag `v1.0.0` pushed
2. **Build Stage 1:** Build all three variants for `linux/amd64` only → export to tar files
3. **Scan Stage:** Run Trivy on all three variants (amd64 tars)
4. **Decision Point:** If any scan fails → release BLOCKED, workflow stops
5. **Build & Push Stage 2:** If all scans pass → build and push all three variants for `linux/amd64,linux/arm64` to both registries
6. **Summary:** Display what was pushed

### Timeline

- **Build (amd64):** ~3-4 min
- **Scan (all 3):** ~3-4 min
- **Push (multi-arch, 20 tags):** ~5-7 min
- **Total:** ~12-18 minutes per release

## Making a New Release (Maintainer Checklist)

### Before Tagging a Release

- [ ] All CI checks on the `main` branch are passing (green)
- [ ] `CHANGELOG.md` is updated with the new features, fixes, and any breaking changes
- [ ] Decide on the next version number following Semantic Versioning rules
- [ ] Build and test all three variants locally to catch issues early:
  ```bash
  # Example for lite variant (repeat for balanced and power)
  docker build -t debugbox:lite-local -f Dockerfile.lite .
  docker run -it --rm debugbox:lite-local
  ```
  Verify basic functionality (shell access, key tools present, no obvious crashes)

### Tag and Trigger the Release

```bash
# Make sure you're on the latest main
git checkout main
git pull origin main

# Create an annotated tag (required for proper GitHub Release integration)
# Replace v1.0.0 with your actual version
git tag -a v1.0.0 -m "Release v1.0.0: brief summary of changes"

# Push the tag → this automatically triggers the GitHub Actions release workflow
git push origin v1.0.0
```

> **Note:** Annotated tags (`-a`) are required so GitHub can associate rich release notes later.

### Monitor the Automated Workflow

1. Go to the repository's **Actions** tab
2. Locate the workflow run named **"Release"** (triggered by the new tag)
3. Wait for completion (~12–18 minutes):
   - Stage 1: Build all variants (linux/amd64) for scanning
   - Stage 2: Trivy security scan (blocks on HIGH/CRITICAL findings)
   - Stage 3: Multi-arch build & push to GHCR + Docker Hub (all tags)
   - Stage 4: Print summary of published tags
4. If the workflow fails:
   - Review the logs for the failing step
   - Fix the root cause on `main` (e.g. vulnerability, build error)
   - Re-run the failed job directly from the Actions UI (GitHub supports re-running jobs on the same tag)
   - **Do not** force-push or delete the tag unless absolutely necessary — it can confuse users

### Verify the Images Were Published

Once the workflow completes successfully, confirm the images are live:

```bash
# Quick smoke test – GHCR (recommended registry)
docker pull ghcr.io/ibtisam-iq/debugbox:balanced-1.0.0
docker pull ghcr.io/ibtisam-iq/debugbox:lite-1.0.0
docker pull ghcr.io/ibtisam-iq/debugbox:power-1.0.0
docker pull ghcr.io/ibtisam-iq/debugbox:1.0.0         # Alias
docker pull ghcr.io/ibtisam-iq/debugbox:latest        # Alias

# Optional: Docker Hub mirror
docker pull mibtisam/debugbox:balanced-1.0.0

# Confirm multi-architecture support
docker inspect ghcr.io/ibtisam-iq/debugbox:balanced-1.0.0 | grep -A 5 Architecture
```

### Final Manual Steps

- [ ] Create the GitHub Release:
  1. Go to the repository's **Releases** page
  2. Click **Draft a new release**
  3. Choose the tag you just pushed (`v1.0.0`)
  4. Set title: `v1.0.0 – [short descriptive title]`
  5. Paste relevant section from `CHANGELOG.md` into the description (include upgrade notes, known issues if any)
  6. Publish the release

- [ ] Update documentation (as needed):
  - Refresh README.md with any new variant/tool changes
  - Update any external docs, website, or getting-started guides
  - Consider bumping version references in examples

- [ ] Announce the release (optional but recommended):
  - Share on X (Twitter), Reddit (r/kubernetes, r/selfhosted, etc.), or relevant forums
  - Notify users in any project channels (Discord, Matrix, etc.)
  - Update any project website changelog

## Release History & Changelog

All releases, changelogs, and detailed notes are available at:
[https://github.com/ibtisam-iq/debugbox/releases](https://github.com/ibtisam-iq/debugbox/releases)

Detailed changes for each version are documented in:
[CHANGELOG.md](CHANGELOG.md)

## Tag Reference (Quick Lookup)

### Latest Tags (Floating per Variant)

```bash
# Latest of each variant
ghcr.io/ibtisam-iq/debugbox:lite          # Latest lite
ghcr.io/ibtisam-iq/debugbox:balanced      # Latest balanced
ghcr.io/ibtisam-iq/debugbox:power         # Latest power
ghcr.io/ibtisam-iq/debugbox:latest        # Latest balanced (alias)

# Explicit -latest suffix
ghcr.io/ibtisam-iq/debugbox:lite-latest
ghcr.io/ibtisam-iq/debugbox:balanced-latest
ghcr.io/ibtisam-iq/debugbox:power-latest
```

### Specific Version Tags

```bash
# Version 1.0.0
ghcr.io/ibtisam-iq/debugbox:1.0.0                # Short form (alias)
ghcr.io/ibtisam-iq/debugbox:lite-1.0.0
ghcr.io/ibtisam-iq/debugbox:balanced-1.0.0
ghcr.io/ibtisam-iq/debugbox:power-1.0.0

# Version 1.0.1
ghcr.io/ibtisam-iq/debugbox:1.0.1                # Short form (alias)
ghcr.io/ibtisam-iq/debugbox:lite-1.0.1
ghcr.io/ibtisam-iq/debugbox:balanced-1.0.1
ghcr.io/ibtisam-iq/debugbox:power-1.0.1
```

### Docker Hub (Alternative Registry)

Same tag patterns, different registry:

```bash
docker.io/mibtisam/debugbox:lite
docker.io/mibtisam/debugbox:balanced
docker.io/mibtisam/debugbox:power
docker.io/mibtisam/debugbox:latest
docker.io/mibtisam/debugbox:1.0.0
docker.io/mibtisam/debugbox:lite-1.0.0
docker.io/mibtisam/debugbox:balanced-1.0.0
docker.io/mibtisam/debugbox:power-1.0.0
```

## Architecture (Design Principles)

### Why Three Variants?

DebugBox is distributed in three variants to meet different user needs:

- **Lite:** For constrained environments (Kubernetes init containers, edge devices, minimal deployments)
- **Balanced:** For most users – balanced between functionality and size (default)
- **Power:** For advanced use cases (SRE, forensics, production incident response)

Users choose based on their environment and needs, not on base OS or minor feature differences.

### Single Repository Model with Aliases

All three variants are in **one repository** (`debugbox`) with **tag suffixes** for discoverability, plus **two convenient aliases** for production use:

**Tag patterns:**
- **Primary:** `debugbox:lite`, `debugbox:balanced`, `debugbox:power` (variant discovery)
- **Floating:** `debugbox:lite-latest`, `debugbox:balanced-latest`, `debugbox:power-latest` (moving targets)
- **Pinned:** `debugbox:lite-1.0.0`, `debugbox:balanced-1.0.0`, `debugbox:power-1.0.0` (immutable)
- **Aliases:** `debugbox:latest` → balanced-latest, `debugbox:1.0.0` → balanced-1.0.0 (convenience)

**Benefits:**
- ✅ **Clear mental model:** Users see one tool with three options
- ✅ **Easy discovery:** `docker pull debugbox:lite`, `docker pull debugbox:balanced`, etc.
- ✅ **Better Docker Hub UX:** One image card with clear variant options
- ✅ **Simpler documentation:** "Use `debugbox` or `debugbox:1.0.0` (default) or switch to `-lite` or `-power`"
- ✅ **Upgrade path:** Users understand `debugbox:1.0.0` → `debugbox:1.0.1`
- ✅ **Production-friendly:** Short aliases (`debugbox:1.0.0`) are clean and memorable

### Why Aliases?

Two aliases make the UX perfect:

1. **`debugbox:latest`** – For users who just want the default (balanced, latest stable)
2. **`debugbox:1.0.0`** – For production users who want version pinning without typing `balanced-1.0.0`

This balances discoverability (people discover `debugbox:power`) with conciseness (production uses `debugbox:1.0.0`).

## Questions or Suggestions

Open an issue: [https://github.com/ibtisam-iq/debugbox/issues](https://github.com/ibtisam-iq/debugbox/issues)

---

**Last Updated:** February 1, 2026  
**Maintained By:** DebugBox Core Team  
**Release Strategy:** Variant-first tagging with version aliases (20 tags per release)