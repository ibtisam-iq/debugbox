# Security Policy

## Supported Versions
Security updates apply to the latest released version of DebugBox.

| Version | Supported |
| ------- | --------- |
| Latest  | ✅        |
| Older   | ❌        |

---

## Reporting a Vulnerability

If you discover a security vulnerability in DebugBox, **DO NOT** open a public GitHub issue.

Please report it privately:

- **Email:** contact@ibtisam-iq.com  
- **PGP Key:** Coming soon  

We aim to respond within **72 hours**.

Please include:

- Description of the issue  
- Steps to reproduce  
- Affected DebugBox variant (`lite`, `balanced`, `power`)  
- Suggested fix (optional)  

---

## Security Practices

DebugBox follows industry-standard container security practices:

- **Image scanning** using Trivy  
- **Fail-on policy** for HIGH and CRITICAL vulnerabilities  
- **SBOM generation** (planned)  
- **Checksum verification** for third-party binaries (e.g., `yq`)  
- **Deterministic builds** using Docker Buildx  
- **Minimal base images** (Alpine)  
- **Non-root execution by default**

---

## Trivy Scan Policy and Exceptions

DebugBox enforces strict Trivy scanning with build failure on all
**HIGH** and **CRITICAL** vulnerabilities.

### Allowed Exceptions

In rare cases, vulnerabilities may be reported inside **third-party static binaries**
that are bundled for usability (e.g., `kubens`).

These vulnerabilities may be allow-listed **only if all of the following are true**:

- The vulnerability originates from **upstream dependencies**
- The binary is **not exposed as a network service**
- The affected code path is **not reachable** in DebugBox’s runtime usage
- No patch is available upstream at the time
- The CVE is **explicitly reviewed and documented**

Such exceptions are tracked in `.trivyignore`.

### Current Allow-Listed CVEs

The following CVEs are currently allow-listed due to upstream limitations:

- `CVE-2023-39325` — golang.org/x/net (kubens)
- `CVE-2025-22868` — golang.org/x/oauth2 (kubens)

These do **not** affect DebugBox’s security posture in practice.

---

## Important Notes

- DebugBox is a **debugging utility image**, not an application server
- No inbound network services are exposed by default
- Third-party tools are included for operator convenience
- Security decisions favor **transparency over silence**

---

Thank you for helping keep DebugBox secure.
