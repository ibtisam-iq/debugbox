# Security Policy

## Reporting Vulnerabilities

If you discover a security vulnerability in DebugBox, please report it responsibly:

**Do not** open a public GitHub issue.

Instead, email security details to the maintainer. Details will be handled confidentially.

---

## Security Scanning

Every DebugBox release is scanned with **Trivy** for known vulnerabilities:

- ✅ HIGH and CRITICAL vulnerabilities fail the build
- ✅ Both amd64 and arm64 are scanned
- ✅ Scan results are logged in CI/CD

---

## Image Security

### By Design

- **Runs as root:** This is a debugging tool, not a production workload
- **No secrets baked in:** Only open-source debugging tools included
- **Minimal attack surface:** Lite variant excludes compilers/runtimes
- **Multi-arch support:** Same security properties on all platforms

### Best Practices

- Pin specific versions in production: `--image=ghcr.io/ibtisam-iq/debugbox:{{ git.tag or git.describe }}`
- Use Lite variant when possible (smallest attack surface)
- Remove debugging pods after troubleshooting
- Monitor for security updates

---

## Supported Versions

Security updates are provided for:
- Current release: Full support
- Previous release: Critical fixes only
- Older releases: Best effort

---

## Disclosure Timeline

For reported vulnerabilities:
1. Initial acknowledgment within 48 hours
2. Assessment and reproduction
3. Fix development
4. Patch release
5. Public disclosure (after fix is released)

---

## Responsible Disclosure

We appreciate security researchers who:
- Report vulnerabilities responsibly
- Provide detailed information
- Allow time for patching before disclosure
- Work with us to verify fixes

---

For full security policy, see [SECURITY.md](https://github.com/ibtisam-iq/debugbox/blob/main/SECURITY.md) in the repository.
