# Security Scanning

How DebugBox images are scanned and secured.

## Trivy Scanning

Every release is scanned with **Trivy** for known vulnerabilities.

### Scan Process

```bash
# Automated in GitHub Actions
trivy image ghcr.io/ibtisam-iq/debugbox:{{ git.tag or git.describe }}
```

### Severity Levels

| Level | Action |
|-------|--------|
| CRITICAL | Build fails |
| HIGH | Build fails |
| MEDIUM | Logged, build continues |
| LOW | Logged, build continues |

### Both Architectures

Both amd64 and arm64 images are scanned:
- ✅ CI/CD scans before publication
- ✅ Results included in build logs
- ✅ Severity thresholds enforced

---

## Dependency Updates

DebugBox dependencies are updated regularly:
- Alpine base image: Latest stable
- Tool binaries: Pinned and tested
- Python packages: Security patches

---

## Known Vulnerabilities

If a vulnerability is discovered:

1. **Assessment:** Severity and impact evaluated
2. **Patching:** Fix applied to base/tools
3. **Testing:** Comprehensive testing before release
4. **Release:** Patch version bumped and released
5. **Notification:** Users informed via GitHub releases

---

## Best Practices

### For Users

- Pin versions in production: `{{ git.tag or git.describe }}`
- Review CVE database before deployment
- Keep images updated to latest
- Remove debug pods after troubleshooting

### For Developers

- Run `make scan` locally before PRs
- Review security advisories
- Keep Dockerfile dependencies updated
- Use minimum required tools per variant

---

## Scan Reports

View current scan status in CI/CD logs:

1. Go to GitHub Actions
2. Select the latest release workflow
3. Check "Scan" step output

---

## Vulnerability Reporting

Found a vulnerability? Report responsibly via [Security Policy](policy.md).

Do not create public GitHub issues for security problems.
