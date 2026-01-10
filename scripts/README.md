# Scripts Directory — Binary Installers

This directory contains **executable installer scripts** used by DebugBox Docker images to install tools that **should not be installed via the OS package manager** (apk).

These scripts exist to keep Dockerfiles **short, readable, and declarative**, while moving procedural logic (downloads, checksums, architecture handling) into clearly named, reusable commands.

---

## What belongs here

A script should live in `scripts/` if **all** of the following are true:

* The tool is installed as a **standalone binary** (not via `apk add`)
* The install requires:

  * version pinning
  * architecture detection
  * checksum verification
* The logic would otherwise bloat the Dockerfile
* The logic may be reused or extended in the future

Examples:

* `install-yq-binary`
* `install-helm-binary`
* `install-k9s-binary`

---

## What does NOT belong here

Do **not** create scripts for:

* Simple `apk add` packages
* One-line installs without verification
* Shell helpers or aliases
* Files that are meant to be **sourced** instead of executed

Those belong directly in Dockerfiles or in `dockerfiles/common/*`.

---

## Naming conventions

Scripts in this directory:

* **Have no `.sh` extension**
* Are named as **commands**, not libraries
* Follow the pattern:

```
install-<tool>-binary
```

Examples:

* `install-yq-binary`
* `install-helm-binary`

Rationale:

* These files are *executables*, not generic shell snippets
* The shebang defines the interpreter, not the filename
* This matches common Unix and infrastructure tooling conventions

---

## Execution model

All scripts in this directory:

* Must include a shebang (e.g. `#!/bin/sh`)
* Must be executable (`chmod +x`)
* Are **executed**, not sourced

Example usage in a Dockerfile:

```dockerfile
COPY scripts /scripts
RUN /scripts/install-yq-binary
```

---

## Script responsibilities

Each installer script must:

1. Own the **default version** of the tool
2. Own **all checksum values**
3. Handle **architecture detection** internally
4. Perform **cryptographic verification** (e.g. SHA256)
5. Install exactly **one tool**
6. Verify the tool after installation

Dockerfiles should **not** reimplement or partially duplicate this logic.

---

## Configuration and overrides

Scripts may allow overrides via environment variables, but **must have safe defaults**.

Example:

```sh
YQ_VERSION="${YQ_VERSION:-v4.50.1}"
```

This allows flexibility without leaking complexity into Dockerfiles.

---

## Design principle

> Dockerfiles describe *what* an image contains.
> Scripts describe *how* complex tools are installed.

Keeping this boundary strict improves:

* readability
* reviewability
* long-term maintainability
* contributor confidence

---

## Summary

* `scripts/` contains **executable binary installers only**
* One script = one tool
* No `.sh` extension by design
* Full ownership of versioning and verification
* Dockerfiles stay clean and declarative

This pattern is intentional and should be followed consistently.
