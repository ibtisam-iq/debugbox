# DebugBox

[![GitHub Actions](https://img.shields.io/github/actions/workflow/status/ibtisam-iq/debugbox/build-and-test.yml?branch=main)](https://github.com/ibtisam-iq/debugbox/actions?query=workflow%3Abuild-and-test)
[![Docker Pulls](https://img.shields.io/docker/pulls/mibtisam/debugbox)](https://hub.docker.com/r/mibtisam/debugbox)
[![License](https://img.shields.io/github/license/ibtisam-iq/debugbox)](LICENSE)

A lightweight, multi-variant Docker toolkit for Kubernetes debugging and cloud-native troubleshooting. Pre-packed with essential tools to eliminate "command not found" in pods—built from real-world CKA/CKAD frustrations.

**Variants:** `base` (7.8MB) • `lite` (66.8MB) • `balanced` (195MB) • `power` (366MB)  
**Registries:** [GHCR](https://ghcr.io/ibtisam-iq/debugbox) • [Docker Hub](https://hub.docker.com/r/mibtisam/debugbox)

## Motivation
As a DevOps transitioner prepping for CKA/CKAD, I wasted hours `kubectl exec`-ing into pods only to hit "command not found" for basics like `curl` or `tcpdump`. DebugBox fixes that: Spin up a pod with everything you need, from DNS checks to packet captures. It's the ephemeral debug env you wish kubectl had—secure, slim, and extensible for SRE workflows.

## Variants
Choose based on needs: Start lite for quick wins, scale to power for forensics.

| Variant | Size | Key Tools | Best For |
|---------|------|-----------|----------|
| **Base** | 7.8MB | Core utils (alpine base) | Custom builds; minimal anchors |
| **Lite** | 66.8MB | bash, curl, jq/yq, iproute2, vim, DNS utils | Ephemeral pods, low-resource clusters, init containers |
| **Balanced** | 195MB | Lite + htop, strace, tcpdump, nmap, iperf3, git, socat | Daily K8s troubleshooting, network probes, API tests |
| **Power** | 366MB | Balanced + tshark, ngrep, iptables/nftables, conntrack, swaks | Deep packet analysis, service mesh, load balancer diagnostics |

[Full tool lists](docs/tools.md) \| [Build your own](CONTRIBUTING.md#adding-tools)

## Quick Start

### Pull & Run Locally
```bash
# Balanced (default)
docker pull ghcr.io/ibtisam-iq/debugbox:balanced
docker run -it --rm ghcr.io/ibtisam-iq/debugbox:balanced bash

# Or lite for speed
docker pull mibtisam/debugbox:lite
```

### Kubernetes Debug Pod
```bash
kubectl run debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox:balanced -- bash

# Example: Test connectivity
kubectl exec -it debug -- curl -v http://kubernetes.default:443

# Network sniff
kubectl exec -it debug -- tcpdump -i any -c 10
```

For Helm deploys: `helm install debugbox charts/debugbox`. See [K8s Guide](docs/user-guide.md).

## Repository Structure
```
debugbox/
├── dockerfiles/          # Variant Dockerfiles + manifest
├── charts/               # Helm for K8s (primary deploy)
├── k8s/                  # Kustomize overlays
├── examples/             # Raw YAML snippets (deprecated)
├── scripts/              # Build/test helpers
├── tests/                # Smoke/integration
├── docs/                 # Guides (architecture.md, user-guide.md)
├── .github/workflows/    # CI: Build, test, release, nightly
├── Makefile              # Local dev targets
├── CHANGELOG.md          # Semantic releases
├── CONTRIBUTING.md       # How to hack
└── ... (governance files)
```

## Security & Supply Chain
- **Scans:** Trivy (fail on HIGH/CRITICAL) in CI.
- **Signing:** Cosign for all images.
- **SBOM:** Syft-generated per release.
- **Builds:** Deterministic, multi-arch (amd64/arm64), rootless support.
- Report vulns privately: [contact@ibtisam-iq.com](mailto:contact@ibtisam-iq.com) or [GitHub Advisory](https://github.com/ibtisam-iq/debugbox/security/advisories/new).

## Development
```bash
make build-balanced  # Specific variant
make test-all        # Smoke + integration
make lint            # Hadolint + shellcheck
```

Nightly CI warms caches at 03:00 UTC for fast PRs. Releases auto-trigger on tags (e.g., `git tag v1.0.0`).

## Alternatives
- **kubectl debug:** Native but tool-light; DebugBox adds 50+ utils.
- **Busybox:** Ultra-minimal; we layer debugging on alpine for balance.
- **Ubuntu debug:** Bloated (1GB+); ours caps at 366MB with security hardening.

## Contributing
New to OSS? Start with [good first issue](https://github.com/ibtisam-iq/debugbox/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22). Read [CONTRIBUTING.md](CONTRIBUTING.md) and adhere to [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md). PRs welcome—add tools, fix vulns, or Helm tweaks!

## License
MIT © Muhammad Ibtisam. See [LICENSE](LICENSE).

## Maintainer
[Muhammad Ibtisam](https://ibtisam-iq.com) – [contact@ibtisam-iq.com](mailto:contact@ibtisam-iq.com)

---

⭐ If DebugBox saves you a debug session, star it. Feedback? Open an issue.