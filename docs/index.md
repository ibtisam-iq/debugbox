# DebugBox

A **lightweight, variant-based debugging container suite for Kubernetes and Docker environments.**

Instead of one oversized debugging image, DebugBox provides three purpose-built variants — from minimal network checks (15MB) to full SRE forensics (110MB).

## Why DebugBox?

Modern Kubernetes pods (distroless, minimal Alpine) often ship **without curl, dig, tcpdump or bash**. Existing solutions like netshoot work but require downloading a 208MB image even for basic network checks.

DebugBox provides **three focused variants** instead of one monolithic image:

- **lite (15 MB)** – Fast pulls for quick network/DNS checks
- **balanced (48 MB)** – Daily-driver for most troubleshooting (recommended)
- **power (110 MB)** – Deep forensics and packet analysis

**4.3× smaller** than netshoot for 90% of use cases → faster pulls, faster incident response.

## Quick Start

```bash
# Debug a running pod
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox

# Run a temporary debugging pod
kubectl run debugbox --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never
```

Inside the container:
```bash
curl -I https://kubernetes.io              # Test connectivity
dig kubernetes.default.svc.cluster.local   # Check DNS
ip route                                   # Inspect routes
kubectl get cm my-config -o yaml | yq      # Parse YAML
tcpdump -i eth0 port 443 -c 10             # Capture packets
```

## Variants at a Glance

| Variant | Size | Use Case | Shell |
|---------|------|----------|-------|
| **lite** | 15 MB | Quick network checks | ash (BusyBox) |
| **balanced** | 48 MB | General troubleshooting | bash |
| **power** | 110 MB | Deep forensics | bash |

**→ [Learn more about variants](variants/overview.md)**

## Registries

Images available on:
- **GHCR (primary):** `ghcr.io/ibtisam-iq/debugbox`
- **Docker Hub (mirror):** `docker.io/mibtisam/debugbox`

Both registries contain identical multi-arch images (amd64 + arm64).

## Key Features

✅ **Minimal variants** – Choose only what you need  
✅ **Fast pulls** – Lite: 15MB, Balanced: 48MB, Power: 110MB  
✅ **Multi-arch** – Works on amd64 (x86), arm64 (Apple Silicon, AWS Graviton, Pi)  
✅ **Kubernetes-ready** – Built for `kubectl debug` and ephemeral containers  
✅ **Deterministic** – Critical binaries pinned with SHA verification  
✅ **Secure** – Scanned with Trivy on every release  

## What's Included

### Lite (15 MB)
- Network: curl, netcat, ip, ping, dig, nslookup
- Data: jq, yq
- Shell: ash (BusyBox)

### Balanced (48 MB) — Recommended
- All lite tools, plus:
- Shell: bash with completion, vim, less
- Network: tcpdump, socat, nmap, mtr, iperf3, iftop, ethtool
- System: htop, strace, lsof, procps, psmisc
- Kubernetes: kubectx, kubens
- VCS: git, and more

### Power (110 MB)
- All balanced tools, plus:
- Forensics: tshark, ltrace
- Routing/firewall: iptables, nftables, conntrack-tools, bird, bridge-utils
- Scripting: Python 3 with pip3

## Common Workflows

### Test Service Connectivity
```bash
kubectl run debugbox --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never

# Inside
curl http://my-service.default.svc.cluster.local:8080
dig my-service.default.svc.cluster.local
```

### Debug Running Pod
```bash
kubectl debug my-app-pod -it \
  --image=ghcr.io/ibtisam-iq/debugbox

# Inside (same network as app)
curl localhost:8080
netstat -tulpn
```

### Capture Network Traffic
```bash
kubectl run debugbox-power --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-power \
  --restart=Never

# Inside
tcpdump -i eth0 -w /tmp/capture.pcap port 443
tshark -i eth0 -f "port 443"
```

**→ [See more workflows](usage/workflows.md)**

## Comparison

```
netshoot:         208 MB  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 100%
DebugBox power:   110 MB  ━━━━━━━━━━━━━━━━━━━━━━ 53%
DebugBox balanced: 48 MB  ━━━━━━━━━ 23%
DebugBox lite:     15 MB  ━━ 7%
busybox:           1.5 MB  ░ <1%
```

## Design Principles

1. **Variants Over Bloat** – Each variant installs only what it promises
2. **Deterministic Builds** – Critical binaries pinned and SHA-verified
3. **Explicit Contracts** – Documentation declares exactly what's included
4. **Debug-First Philosophy** – Runs as root (debugging tool, not production workload)
5. **Engineering Clarity** – Makefile-driven, automated CI/CD, security scanning

## Navigation

- **[Getting Started](getting-started/quick-start.md)** – 60-second setup
- **[Variants](variants/overview.md)** – Detailed variant comparison
- **[Kubernetes Usage](usage/kubernetes.md)** – kubectl debug, ephemeral containers, sidecar patterns
- **[Docker Usage](usage/docker.md)** – Docker and Docker Compose examples
- **[Workflows](usage/workflows.md)** – Real-world debugging scenarios
- **[Reference](reference/manifest.md)** – Complete tooling reference and image details
- **[Development](development/local-setup.md)** – Local builds, testing, contribution guidelines
- **[Security](security/policy.md)** – Reporting vulnerabilities, security scanning

## Local Development

```bash
# Clone repository
git clone https://github.com/ibtisam-iq/debugbox.git
cd debugbox

# Build all variants
make build-all

# Run tests
make test-all

# Security scan
make scan

# Preview documentation
pip install -r requirements.txt
mkdocs serve
```

## Links

- **GitHub:** https://github.com/ibtisam-iq/debugbox
- **Author:** [Muhammad Ibtisam](https://github.com/ibtisam-iq)
- **License:** [MIT](https://github.com/ibtisam-iq/debugbox/blob/main/LICENSE)

---

**Ready to debug? Start with [Quick Start](getting-started/quick-start.md) or [choose a variant](variants/overview.md).**
