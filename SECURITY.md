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

## Known Ignored Vulnerabilities

We use automated Trivy scanning on every build/release to block HIGH/CRITICAL vulnerabilities in the Alpine base and most dependencies. However, some static Go binaries (specifically **kubens** from ahmetb/kubectx) embed older versions of third-party Go modules:

- `golang.org/x/net` (v0.8.0)
- `golang.org/x/oauth2` (pre-v0.27.0)

These trigger the following HIGH-severity findings in Trivy:

- **CVE-2023-39325** (HTTP/2 rapid stream resets causing server resource exhaustion)  
  - Fixed in golang.org/x/net v0.17.0  
  - **Why ignored**: This is a server-side DoS vulnerability. kubens is a client-only tool with no exposed HTTP/2 server in DebugBox containers. Not exploitable in our runtime context (ephemeral debug pods).

- **CVE-2025-22868** (Unexpected memory consumption during malformed token parsing in oauth2/jws)  
  - Fixed in golang.org/x/oauth2 v0.27.0  
  - **Why ignored**: kubens may parse OAuth tokens, but in DebugBox usage (trusted Kubernetes clusters, no untrusted inputs), malformed tokens from attackers are not a realistic threat vector. Low exploitability in isolated debug sessions.

- **CVE-2025-61728** (HIGH) in yq binary (golang stdlib archive/zip DoS via malicious ZIP index)
  - Fixed in Go 1.25.6 / 1.24.12
  - **Why ignored**: yq in DebugBox processes trusted Kubernetes YAML output only — no malicious ZIP archives fed to it. Low exploitability in ephemeral debug pods.  

These are suppressed via `.trivyignore` (see repository root) to avoid false-positive build failures. The kubectx project has not yet bumped these dependencies in recent releases (last stable v0.9.5 from 2023). We monitor upstream and will rebuild with updated versions if they become available or if risk assessment changes.

For full transparency, these are **not** vulnerabilities in the DebugBox base or core tooling — only in one optional utility binary.

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

**Last Updated:** January 31, 2026  
**Maintained By:** DebugBox Core Team
