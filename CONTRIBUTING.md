# Contributing to DebugBox

Thank you for your interest in contributing to DebugBox!

DebugBox is a focused, variant-based debugging container suite for Kubernetes and Docker. We welcome bug fixes, improvements, documentation updates, CI enhancements, and thoughtful tooling proposals.

### Found a Bug?
If you spot a bug:

- Search existing [issues](https://github.com/ibtisam-iq/debugbox/issues)
- If none exists, open a new issue with version, variant, environment, and repro steps

We triage issues regularly.

### First-Time Contributor?
Welcome! 👋 Documentation fixes and small improvements are great starting points. We're happy to help you through your first PR.

---

## How to Contribute

### 1. Fork and Clone
```bash
git clone https://github.com/ibtisam-iq/debugbox.git
cd debugbox
```

### 2. Create a Feature Branch
```bash
git checkout -b feat/add-traceroute-to-lite
# or fix/, docs/, ci/, chore/
```

### 3. Make Your Changes
- Follow Dockerfile and script style guidelines below
- **Always update `docs/manifest.yaml`** for tool or shell changes (source of truth)
- Test locally:

```bash
make build-<variant>    # e.g., make build-balanced
make test-<variant>
make scan               # Trivy check
```

### 4. Open a Pull Request
- Target: `main` branch
- Title format (Conventional Commits):

```
feat: add traceroute to lite
fix: correct yq version in power
docs: improve usage examples
ci: optimize build cache
chore: update alpine base
```
- PR must pass CI (build, test, scan, lint)

### 5. Discuss and Iterate
Be responsive to feedback. We aim for constructive, respectful reviews.

---

## Adding New Tools
Please justify in your PR or issue:
1. What debugging gap does it fill?
2. Which variant(s)?
3. Approximate size impact?
4. Does it overlap with existing tools?

**Required:** Update `docs/manifest.yaml` with the new tool under the correct category.

---

## Style Guidelines
### Dockerfiles
- Pin versions where possible
- Combine `apk add` in single RUN with cleanup
- Comment _why_, not _what_
```dockerfile
RUN apk add --no-cache curl netcat-openbsd bind-tools \
    && rm -rf /var/cache/apk/*
```

### Shell Scripts
- Shebang: `/bin/sh` (unless bash needed)
- `set -euo pipefail`
- Comment non-obvious logic

---

## Scope and Focus
DebugBox prioritizes **small, secure, ephemeral debugging images**. We generally avoid:
- Deployment/GitOps tools
- Heavy editors or full language runtimes
- Build/compilation tools

If you believe an exception is justified for debugging, open an issue to discuss.

---

## Testing & CI
(See local testing commands above)  
All PRs run full multi-arch builds, smoke tests, Trivy scans, and Hadolint.

---

## Code of Conduct
Please follow our [Code of Conduct](CODE_OF_CONDUCT.md).

---

Questions? → [Issues](https://github.com/ibtisam-iq/debugbox/issues) or [Email](mailto:contact@ibtisam-iq.com)

Thank you for helping make DebugBox better!
