# DebugBox – Release Process

This document describes **how DebugBox container images are released**, versioned, and published.

It is written for:

* Project maintainers
* Contributors
* Users who want to understand release guarantees

---

## Overview

DebugBox follows a **tag-based release model**.

* Development happens on branches (primarily `main`)
* Releases are created **only from Git tags**
* Container images are published automatically via GitHub Actions
* Images are pushed to:

  * GitHub Container Registry (GHCR)
  * Docker Hub

There is a strict separation between:

* **Development & testing**
* **Releasing & publishing**

---

## What Triggers a Release

A release is triggered **only** when a version tag is pushed.

Example:

```bash
git tag v1.0.0
git push origin v1.0.0
```

This action:

* Freezes the current state of the repository
* Triggers the `release.yml` GitHub Actions workflow
* Builds and publishes container images

> Pushing to `main` alone does **not** create a release.

---

## Versioning Scheme

DebugBox uses **Semantic Versioning**:

```
MAJOR.MINOR.PATCH
```

Examples:

* `v1.0.0`
* `v1.0.1`
* `v1.1.0`

Rules:

* Versions are immutable once released
* Older versions remain available indefinitely
* `latest` always points to the newest release of each variant

---

## Released Images

Each release publishes the following container images:

### Base Image (manual release)

```
ghcr.io/ibtisam-iq/debugbox-base
```

> The base image is released manually and versioned independently.

---

### Lite Variant

```
ghcr.io/ibtisam-iq/debugbox-lite:<version>
ghcr.io/ibtisam-iq/debugbox-lite:latest

docker.io/<dockerhub-user>/debugbox-lite:<version>
docker.io/<dockerhub-user>/debugbox-lite:latest
```

Purpose:

* Minimal footprint
* Fast pull times
* Basic debugging tools

---

### Balanced Variant (Default)

```
ghcr.io/ibtisam-iq/debugbox-balanced:<version>
ghcr.io/ibtisam-iq/debugbox-balanced:latest

ghcr.io/ibtisam-iq/debugbox:<version>
ghcr.io/ibtisam-iq/debugbox:latest

docker.io/<dockerhub-user>/debugbox-balanced:<version>
docker.io/<dockerhub-user>/debugbox-balanced:latest

docker.io/<dockerhub-user>/debugbox:<version>
docker.io/<dockerhub-user>/debugbox:latest
```

Purpose:

* Recommended default
* Daily-driver debugging image
* Used when no variant is explicitly specified

---

### Power Variant

```
ghcr.io/ibtisam-iq/debugbox-power:<version>
ghcr.io/ibtisam-iq/debugbox-power:latest

docker.io/<dockerhub-user>/debugbox-power:<version>
docker.io/<dockerhub-user>/debugbox-power:latest
```

Purpose:

* Advanced SRE and forensics tooling
* Larger footprint
* Explicit opt-in

---

## Default Image Behavior

When users pull:

```bash
docker pull ghcr.io/ibtisam-iq/debugbox
```

They receive:

* The **Balanced** variant
* The **latest** released version

This behavior is intentional and documented.

---

## CI vs Release Responsibilities

### CI Workflow (`ci.yml`)

Runs on:

* Pushes to `main`
* Pull requests

Responsibilities:

* Build validation
* Smoke tests
* Image size reporting
* Trivy security scanning
* **No publishing**

---

### Release Workflow (`release.yml`)

Runs on:

* Version tags (`vX.Y.Z`)

Responsibilities:

* Multi-arch builds (`amd64`, `arm64`)
* Final Trivy security scan
* Publishing to registries
* Tagging images (`version`, `latest`)

---

## Security Guarantees

Before any image is published:

* It is built from a tagged commit
* It passes CI validation
* It is scanned with Trivy
* Releases fail on **HIGH** or **CRITICAL** vulnerabilities

This ensures:

* Reproducibility
* Traceability
* User trust

---

## GitHub Releases (Mandatory)

For every DebugBox version, a **GitHub Release page MUST be created**.

* Git tags (`vX.Y.Z`) are the technical trigger for builds and publishing.
* GitHub Releases are the **human-facing release artifact**.
* They serve as the official record of:

  * What changed
  * What was released
  * Which version users should consume

Creating a GitHub Release page is **mandatory for all releases**.

---

### Current Process (Manual)

At present, GitHub Releases are created **manually** after pushing a version tag.

Typical flow:

1. Push the version tag:

   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
2. The release workflow builds and publishes container images.
3. A GitHub Release page is created manually:

   * Select the existing tag (`v1.0.0`)
   * Add release notes
   * Publish the release

This manual step is intentional at this stage to ensure:

* Clear communication
* Reviewed release notes
* Maintainer control

---

### Future Direction (Automated)

In the future, GitHub Release creation **may be automated** as part of the release workflow.

When automated, this will:

* Still require a version tag
* Auto-generate release notes
* Create the GitHub Release page programmatically

Automation will **not** change the requirement that:

> Every release must have a GitHub Release page.

---

## Making a New Release (Checklist)

1. Ensure `main` is green (CI passing)
2. Decide the next version number
3. Create and push a tag:

   ```bash
   git tag vX.Y.Z
   git push origin vX.Y.Z
   ```
4. Monitor GitHub Actions
5. Verify images in:

   * GitHub Packages
   * Docker Hub

---

## Release Philosophy

* Releases are **intentional**
* Automation does not guess intent
* Stability is favored over speed
* Users can always pin exact versions

---

## Questions or Changes

Any change to this release process should be treated as:

* A maintainer decision
* A documented change
* Potentially a breaking change
