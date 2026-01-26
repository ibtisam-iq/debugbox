# Security Policy

DebugBox takes security seriously. All released images follow strict practices to minimize risk.

## Vulnerability Reporting

**Do not open public GitHub issues for security vulnerabilities.**

Please report privately via **[Email](mailto:contact@ibtisam-iq.com)**.

**Subject:** `[SECURITY] DebugBox vulnerability: [brief description]`

Include:

- Description and steps to reproduce
- Affected variant and version
- Potential impact

We follow responsible disclosure:

- Acknowledgment within 72 hours
- Fix timeline based on severity
- Patch released before public announcement
- Credit given (if desired)

→ Full policy and GitHub Security Advisories: **[SECURITY.md on GitHub](https://github.com/ibtisam-iq/debugbox/blob/main/SECURITY.md)**

## Security Practices

### Automated Scanning
Every release is scanned with **Trivy**:

- HIGH and CRITICAL vulnerabilities **block release**
- Both `amd64` and `arm64` images scanned
- Results logged in GitHub Actions

Local scanning:
```bash
make scan
```

### Image Design
- **Runs as root** — required for tools like `tcpdump`, `strace` (ephemeral debugging only)
- **No baked-in secrets**
- **Minimal variants** — lite excludes compilers/runtimes
- **Pinned dependencies** — critical tools version-locked and SHA-verified where possible

### Support Policy
From **[RELEASE.md](https://github.com/ibtisam-iq/debugbox/blob/main/RELEASE.md)**:

| Version       | Support                  | Security Patches             |
|---------------|--------------------------|------------------------------|
| Current       | Full (12 months)         | All severities               |
| Previous (N-1)| Security-only (6 months) | HIGH/CRITICAL only           |
| Older         | Community/best-effort    | None guaranteed              |

## Best Practices for Users

- **Pin versions** in production:
  ```bash
  ghcr.io/ibtisam-iq/debugbox:v1.0.0
  ```
- Use **lite** variant when possible (smallest attack surface)
- Run in isolated namespaces
- Delete debugging pods after use
- Monitor GitHub releases and security advisories

## Acknowledgments

Thank you to security researchers who report issues responsibly.

**Hall of Fame:** *No reports yet*

→ Subscribe to security alerts: Watch → Custom → Security alerts on GitHub
