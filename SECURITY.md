# Security Policy

## Supported Versions

Security updates are provided according to our release support windows:

| Version            | Status            | Security Patches       | Support Duration |
|--------------------|-------------------|------------------------|------------------|
| Latest (v1.x.x)    | ✅ Full support   | All severity levels    | 12 months        |
| Previous (N-1)     | ✅ Security-only  | HIGH/CRITICAL only     | 6 months         |
| Older (N-2+)       | ⚠️ Community     | None guaranteed        | Best effort      |

See [RELEASE.md](RELEASE.md) for the complete release and support policy.

---

## Reporting a Vulnerability

**Do not** open a public GitHub issue for security vulnerabilities.

Please report privately via **[email](mailto:contact@ibtisam-iq.com)**.

**Subject:** `[SECURITY] DebugBox vulnerability: [brief description]`

Include as much detail as possible:
- Description and steps to reproduce
- Affected variant, version, and architecture
- Potential impact
- Suggested fix (optional)

### Expected Response
- Acknowledgment within 72 hours
- Assessment and fix timeline based on severity (CRITICAL: ~7 days, HIGH: ~14 days)
- Coordinated disclosure: Patch released first, then GitHub Security Advisory ~7 days later
- Credit in the advisory (if desired)

Public disclosure occurs after a patch is available or 90 days, whichever comes first.

---

## Security Advisories

Tracked vulnerabilities and patches:  
https://github.com/ibtisam-iq/debugbox/security/advisories

Subscribe via GitHub Watch → Custom → Security alerts.

---

## Security Practices

DebugBox incorporates container security best practices:

- Automated Trivy scanning on every release (blocks HIGH/CRITICAL vulnerabilities)
- Minimal Alpine Linux base with pinned dependencies
- Checksum-verified third-party tools
- Images designed for **ephemeral debugging use** (short-lived, no exposed services)

### Running as Root
DebugBox intentionally runs as root to enable common debugging tasks (e.g., `tcpdump`, process inspection, privileged volume access). This is standard for diagnostic containers.

**Mitigations:**
- Ephemeral/short-lived usage only
- No network services exposed
- Intended for isolated/trusted environments

Users can override with non-root if needed:
```bash
docker run -it --user 1000:1000 ghcr.io/ibtisam-iq/debugbox-lite
```

> Note: Some tools may require elevated privileges.

---

## Important Notes

DebugBox is a **debugging utility** for:
- Kubernetes ephemeral containers
- Short-lived diagnostic sessions

**Not intended** for production workloads, long-running services, or exposed endpoints.

By using DebugBox, you trust the maintainers, bundled tools, and source registries (GHCR/Docker Hub).

---

## Best Practices for Users

- Pin to specific versions: `ghcr.io/ibtisam-iq/debugbox:v1.0.0`
- Use in isolated namespaces
- Apply Kubernetes network policies
- Run with `--rm` for ephemeral sessions

---

## Acknowledgments

Thank you to security researchers who report issues responsibly.

**Hall of Fame:** *No reports yet*

---

**Last Updated:** January 27, 2026  
**Maintained By:** DebugBox Core Team
