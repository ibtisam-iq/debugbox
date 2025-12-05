# Security Policy

## Supported Versions
Security updates apply to the latest released version of DebugBox.

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |
| Older   | :x:                |

## Reporting a Vulnerability
If you find a security vulnerability in DebugBox, **DO NOT** open a public GitHub issue.

Please report it privately:

- **Email:** contact@ibtisam-iq.com 
- **PGP Key (optional):** Coming soon

We aim to respond within **72 hours**.

Please include:

- Description of the issue  
- Steps to reproduce  
- Affected DebugBox variant (lite / balanced / power)  
- Suggested fix (optional)

## Security Practices
DebugBox adheres to:

- **Image signing** using Cosign  
- **SBOM generation** using Syft  
- **Trivy scanning** (fail on HIGH/CRITICAL vulnerabilities)  
- **Checksum verification** of third-party binaries (e.g., yq)  
- **Deterministic builds** with Buildx & pinned versions where possible  

Thank you for helping keep DebugBox secure.
