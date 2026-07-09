# Security Policy

DebugBox takes security seriously. All released images follow strict practices to minimize risk.

## Vulnerability Reporting

**Do not open public GitHub issues for security vulnerabilities.**

Please report privately via **[Email](mailto:contact@ibtisam-iq.com)**.

**Subject:** `[SECURITY] DebugBox vulnerability: [brief description]`

Include:

- Description and steps to reproduce
- Affected variant and version (e.g., `power-1.0.0`)
- Potential impact and severity assessment

We follow responsible disclosure:

- **Acknowledgment:** Within 72 hours
- **Investigation:** Details shared via private discussion
- **Fix timeline:** Based on severity (HIGH/CRITICAL: immediate)
- **Patch release:** Before public announcement
- **Credit:** Given if desired

→ Full policy on GitHub: **[SECURITY.md](https://github.com/ibtisam-iq/debugbox/blob/main/SECURITY.md)**

## Security Practices

### Automated Vulnerability Scanning

Every release is scanned with **Trivy**:

- HIGH and CRITICAL vulnerabilities **block release entirely**
- All three variants (lite, balanced, power) scanned
- Both `linux/amd64` and `linux/arm64` validated
- Results logged in GitHub Actions workflow

**Why only amd64 scanning before push?**

- 99% of vulnerabilities are in shared base layers (OS packages, dependencies)
- amd64 and arm64 have identical software stacks (only CPU instruction sets differ)
- Industry standard: Docker Official Images, Python, Node, Redis all follow this pattern

Local scanning:
```bash
make scan
```

### Image Design Security

- **Runs as root** -- required for tools like `tcpdump`, `strace` (ephemeral debugging only)
- **No baked-in secrets** -- credentials not compiled in
- **Minimal variants** -- lite excludes compilers/development tools to reduce attack surface
- **Pinned dependencies** -- critical tools version-locked and SHA-verified where possible
- **Alpine Linux base** -- minimal (~3.9 MB) attack surface vs. Debian/Ubuntu

### Release Security

From **[RELEASE.md](https://github.com/ibtisam-iq/debugbox/blob/main/RELEASE.md)**:

| Version | Support Duration | Security Patches |
|---------|------------------|------------------|
| Current (v1.x) | 12 months | All severities |
| Previous (v1.x-1) | 6 months | HIGH/CRITICAL only |
| Older (v1.x-2+) | Community/best-effort | None guaranteed |

**Example:** When v1.1.0 is released:

- v1.0.x gets 6 months of security-only patches
- v0.9.x shifts to community support

### Immutable Released Images

- **Released versions never change** -- once published, images are immutable
- **Older versions remain available forever** -- for historical reference or rollback
- **If a vulnerability is found:**
    1. Patched version released immediately (e.g., v1.0.0 → v1.0.1)
    2. Old release marked with warning in GitHub Releases
    3. Users on `:latest` auto-receive fix
    4. Users on pinned versions can upgrade at their discretion

## Best Practices for Users

### Version Pinning (Strongly Recommended)

**Production:**
```bash
# Always pin version AND variant
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:1.0.0
docker run -it ghcr.io/ibtisam-iq/debugbox:lite-1.0.0
```

**Never use `:latest` in production manifests.**

### Variant Selection

Smaller variants have smaller attack surfaces. Use the smallest variant that fits your task. See **[Variants Overview](../variants/overview.md)**.

### Runtime Hygiene

- Run in isolated namespaces
- Delete debugging pods immediately after use
- Don't leave debugging containers running in production
- Monitor GitHub security advisories: watch → Custom → Security alerts

### Multi-Architecture Considerations

- DebugBox is identical across amd64 and arm64 (same security guarantees)
- No architecture-specific vulnerabilities known
- Both architectures scanned before release

## Known Vulnerabilities

All previously suppressed CVEs have been resolved. kubectx/kubens is built from source with patched dependencies, and yq uses a current binary release.

All three variants pass Trivy scanning with zero HIGH/CRITICAL findings. See **[SECURITY.md](https://github.com/ibtisam-iq/debugbox/blob/main/SECURITY.md)** for details.

---

## Quick Links

- **Report vulnerability:** [Email](mailto:contact@ibtisam-iq.com)
- **GitHub Security Advisories:** [github.com/ibtisam-iq/debugbox/security](https://github.com/ibtisam-iq/debugbox/security)
- **Releases & Security Notes:** [github.com/ibtisam-iq/debugbox/releases](https://github.com/ibtisam-iq/debugbox/releases)
- **Subscribe to alerts:** Watch repository → Custom → Security alerts
