# DebugBox

[![CI – Build, Validate & Smoke Test](https://github.com/ibtisam-iq/debugbox/actions/workflows/ci.yml/badge.svg)](https://github.com/ibtisam-iq/debugbox/actions/workflows/ci.yml)

**A lightweight, variant-based debugging container suite for Kubernetes and Docker environments.**

Instead of one oversized debugging image, DebugBox provides three purpose-built variants — from minimal network checks (15MB) to full SRE forensics (110MB).

**Variants:** `lite (15MB)` -  `balanced (48MB)` -  `power (110MB)`  
**Registries:** [GHCR](https://ghcr.io/ibtisam-iq/debugbox) -  [Docker Hub](https://hub.docker.com/r/mibtisam/debugbox)

---

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

---

## Motivation

During CKA/CKAD prep and production troubleshooting, I repeatedly encountered a frustrating pattern:

```bash
$ kubectl exec -it my-pod -- curl
exec: "curl": executable file not found
```

Modern production pods (distroless, Alpine) ship without debugging tools. Existing solutions like netshoot work but require downloading a 208MB image even for basic network checks.

DebugBox solves this by providing **three focused variants** instead of one monolithic image:
- **lite (15MB):** Fast pull for quick network/DNS checks
- **balanced (48MB):** Daily-driver for most troubleshooting
- **power (110MB):** Deep forensics and packet analysis

The goal is simple: **pull only what you need, get debugging done faster.**

---

## Variants

### **lite** — Minimal & Fast (15 MB)

**Use when:** You need quick network checks, DNS debugging, or minimal tooling in resource-constrained clusters.

**What's included:**
- Network: `curl`, `netcat`, `ip`, `ping`, `dig`, `nslookup`
- Data: `jq`, `yq` (Alpine package)
- Shell: `ash` (BusyBox)

**Example:**
```bash
kubectl run debugbox-lite --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-lite \
  --restart=Never
```

---

### **balanced** — Recommended Default (48 MB)

**Use when:** General Kubernetes debugging, troubleshooting live pods, daily workflows.

**Adds to lite:**
- Shell: `bash` with completion
- Editors: `vim`, `less`
- Network: `tcpdump`, `nmap`, `mtr`, `socat`, `iperf3`, `iftop`, `ethtool`
- System: `htop`, `strace`, `lsof`, `procps`, `psmisc`
- Kubernetes: `kubectx`, `kubens`
- VCS: `git`
- Filesystem: `file`, `tar`, `gzip`

**Example:**
```bash
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox
```

> The unqualified `debugbox` image always points to `balanced`.

---

### **power** — Full SRE Toolkit (110 MB)

**Use when:** Deep network forensics, packet captures, routing/firewall debugging.

**Adds to balanced:**
- Forensics: `tshark` (Wireshark CLI), `ltrace`
- Network: `fping`, `speedtest-cli`, `nmap-nping`, `nmap-scripts`
- Routing: `iptables`, `nftables`, `conntrack-tools`, `bird`, `bridge-utils`
- Editors: `nano` (in addition to vim)
- Scripting: Python (`pip3`)
- Pinned tools: `yq` v4.x binary (SHA-verified, not Alpine package)

**Example:**
```bash
kubectl run debugbox-power --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-power \
  --restart=Never
```

---

## Common Workflows

### Debug a Running Pod

```bash
# Attach ephemeral container
kubectl debug my-app-pod -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --target=my-app-container

# Test service connectivity
curl -v http://localhost:8080/health
netstat -tulpn | grep 8080
```

---

### Test Service Connectivity

```bash
kubectl run debugbox --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never

# Inside debugbox
curl -v http://my-service.default.svc.cluster.local:8080
dig my-service.default.svc.cluster.local
traceroute my-service.default.svc.cluster.local
```

---

### Capture Network Traffic

```bash
# Use Power variant for tshark
kubectl run debugbox --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-power \
  --restart=Never

# Capture packets
tcpdump -i eth0 -w /tmp/capture.pcap port 443

# Or use interactive tshark
tshark -i eth0 -f "port 443"
```

---

### Debug Node Networking

```bash
# Run on host network namespace
kubectl run debugbox-host --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --overrides='{"spec":{"hostNetwork":true}}' \
  --restart=Never

# Inspect host network
ip route
ip neigh
iptables -L -n
```

---

### Sidecar Debugging

**Create `debugbox-sidecar.yaml`:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-with-debugbox
spec:
  containers:
  - name: app
    image: nginx:alpine
    ports:
    - containerPort: 80
  
  - name: debugbox
    image: ghcr.io/ibtisam-iq/debugbox
    command: ["sleep", "infinity"]
```

**Deploy:**
```bash
kubectl apply -f debugbox-sidecar.yaml
kubectl exec -it app-with-debugbox -c debugbox -- bash

# Both containers share network namespace
curl localhost:80  # Hits nginx
```

---

### Docker Network Debugging

**Debug another container's network:**
```bash
docker run -it --rm \
  --net container:my-app-container \
  ghcr.io/ibtisam-iq/debugbox
```

**Debug host network:**
```bash
docker run -it --rm \
  --net host \
  ghcr.io/ibtisam-iq/debugbox
```

---

## Image Tags & Registries

### Registries

Images are published to two registries with identical content:

```bash
# GitHub Container Registry (Primary)
ghcr.io/ibtisam-iq/debugbox-lite
ghcr.io/ibtisam-iq/debugbox-balanced
ghcr.io/ibtisam-iq/debugbox-power

# Docker Hub (Mirror)
docker.io/mibtisam/debugbox-lite
docker.io/mibtisam/debugbox-balanced
docker.io/mibtisam/debugbox-power
```

### Tagging

Each variant is published with:
- **Semantic version tags:** `v1.0.0`, `v1.0.1`, etc.
- **Rolling `latest` tag:** Tracks most recent stable release

**Examples:**
```bash
# Pinned version (recommended for CI/CD)
kubectl ... --image=ghcr.io/ibtisam-iq/debugbox:v1.0.0

# Latest stable (good for interactive debugging)
kubectl ... --image=ghcr.io/ibtisam-iq/debugbox:latest

# Specific variant
kubectl ... --image=ghcr.io/ibtisam-iq/debugbox-lite:latest
```

### Default Variant

The unqualified image name points to `balanced`:
```
ghcr.io/ibtisam-iq/debugbox == ghcr.io/ibtisam-iq/debugbox-balanced
```

---

## Multi-Architecture Support

All images are published as multi-architecture manifests supporting:
- `linux/amd64` (x86_64)
- `linux/arm64` (aarch64)

This works seamlessly on:
- Apple Silicon (M1/M2/M3/M4)
- AWS Graviton / Azure Ampere instances
- Raspberry Pi (64-bit)
- Standard x86_64 servers

No platform-specific tags are required. Docker/containerd automatically pulls the correct architecture.

---

## Image Sizes

Compressed sizes:

| Variant | amd64 | arm64 |
|---------|-------|-------|
| lite | 15 MB | 15 MB |
| balanced | 48 MB | 48 MB |
| power | 110 MB | 103 MB |

**For comparison:**
- netshoot: 208 MB (single variant)
- busybox: 1.5 MB (minimal, no debugging tools)

---

## Tooling Reference

Each variant ships a curated set of tools. The authoritative tool list is documented in:

**[`docs/manifest.yaml`](docs/manifest.yaml)** — source of truth for included tools

**Quick overview:**

| Category | Lite | Balanced | Power |
|----------|------|----------|-------|
| Network basics (curl, ip, ping) | ✓ | ✓ | ✓ |
| DNS tools (dig, drill) | ✓ | ✓ | ✓ |
| JSON/YAML parsing | ✓ | ✓ | ✓ |
| Bash shell | ✗ | ✓ | ✓ |
| Packet capture (tcpdump) | ✗ | ✓ | ✓ |
| Process inspection (strace, lsof) | ✗ | ✓ | ✓ |
| Kubernetes helpers (kubectx) | ✗ | ✓ | ✓ |
| Deep forensics (tshark, ltrace) | ✗ | ✗ | ✓ |
| Routing/firewall (iptables, nftables) | ✗ | ✗ | ✓ |

---

## Design Principles

### Variants Over Bloat
Each variant installs only what it promises. Balanced doesn't carry forensics tools it doesn't need. Lite stays minimal.

### Deterministic Builds
Critical binaries are pinned and SHA-verified (e.g., `yq` in Power variant). This prevents unexpected version drift.

### Explicit Contracts
[`docs/manifest.yaml`](docs/manifest.yaml) documents exactly what tools are included in each variant. No hidden packages.

### Debug-First Philosophy
Runs as root by design. This is a debugging tool, not a production workload.

### Engineering Clarity
Makefile-driven builds, CI/CD automation, and Trivy security scans on every release.

---

## What DebugBox Is NOT

- **Not a sidecar container:** Use `kubectl debug` ephemeral containers for most cases
- **Not production-workload ready:** Runs as root; intended for debugging only
- **Not a monolithic toolbox:** Each variant is focused; use the right one for the job
- **Not a security scanner:** This is for troubleshooting, not vulnerability assessment

---

## Local Development

DebugBox uses a Makefile as the primary developer interface.

### Build Images

```bash
# Build single variant
make build-lite
make build-balanced
make build-power

# Build all variants
make build-all
```

### Run Tests

```bash
# Smoke test specific variant
make test-balanced

# Test all variants
make test-all
```

### Security Scanning

```bash
# Scan all images with Trivy
make scan
```

### Multi-Architecture Builds

```bash
# Build for specific platform
PLATFORM=linux/arm64 make build-balanced

# Default builds for both amd64 and arm64
make build-all
```

### Linting

```bash
# Lint Dockerfiles with hadolint
make lint
```

---

## Project Structure

```
.
├── dockerfiles/
│   ├── Dockerfile.base         # Shared Alpine foundation
│   ├── Dockerfile.lite         # Lite variant
│   ├── Dockerfile.balanced     # Balanced variant
│   ├── Dockerfile.power        # Power variant
│   └── common/
│       ├── balanced.packages   # Shared package installation
│       └── balanced.verify     # Verification/smoke tests
│
├── docs/
│   └── manifest.yaml           # Authoritative tooling contract
│
├── scripts/
│   ├── install-yq-binary       # Pinned yq installer (SHA-verified)
│   └── README.md
│
├── tests/
│   ├── smoke.sh                # Local smoke tests
│   └── ci-smoke.sh             # CI smoke tests (no network)
│
├── examples/
│   ├── sidecar.yaml            # Sidecar deployment example
│   └── host-network.yaml       # Host network debugging
│
├── .github/workflows/
│   ├── ci.yml                  # Build + test on every push
│   └── release.yml             # Publish on Git tags
│
├── Makefile                    # Developer interface
├── README.md                   # This file
├── RELEASE.md                  # Release process
├── CONTRIBUTING.md             # Contribution guidelines
├── CHANGELOG.md                # Version history
├── SECURITY.md                 # Security policy
└── LICENSE                     # MIT License
```

---

## Release Model

**Versioning:** Semantic versioning (`vX.Y.Z`)

**Automated workflow:**
1. Tag pushed (e.g., `git tag v1.0.0 && git push origin v1.0.0`)
2. GitHub Actions triggered
3. Multi-arch images built (amd64 + arm64)
4. Trivy security scan (fails on HIGH/CRITICAL vulnerabilities)
5. Images pushed to GHCR + Docker Hub
6. Tags published: `vX.Y.Z` + `latest`

**Detailed process:** See [`RELEASE.md`](RELEASE.md)

---

## Contributing

Contributions are welcome. Before opening a PR:

1. **Identify the variant** — Which image does your change affect?
2. **Check for duplication** — Does this tool overlap with existing functionality?
3. **Consider image size** — Will this bloat the image unnecessarily?
4. **Test locally** — Use `make build-<variant>` and `make test-<variant>`
5. **Update `docs/manifest.yaml`** — Document user-visible changes

### Guidelines

**Do:**
- Add tools that fill genuine debugging gaps
- Group tools logically (network, system, editors)
- Pin critical binaries with SHA verification
- Test on both amd64 and arm64 if possible

**Don't:**
- Add overlapping tools (e.g., `wget` when `curl` exists)
- Bloat Lite variant with heavy packages
- Skip `docs/manifest.yaml` updates
- Introduce undocumented helpers or behavior

**Full guidelines:** [`CONTRIBUTING.md`](CONTRIBUTING.md)

---

## Comparison to Alternatives

| Tool       | Size (amd64) | Variants | Multi-Arch | Kubernetes-Focused | Pinned Binaries |
|-----------|--------------|----------|------------|-------------------|-----------------|
| **DebugBox** | 15-110 MB | ✓ (3)   | ✓          | ✓                 | ✓               |
| nicolaka/netshoot | 208 MB | ✗ (1) | ✓        | ✓                 | ✗               |
| busybox    | 1.5 MB       | ✗ (1)   | ✓          | ✗                 | ✗               |

**DebugBox differentiators:**
- **Three focused variants** vs. one-size-fits-all
- **Smaller footprint** for ephemeral use cases (Lite: 15MB vs. netshoot: 208MB)
- **Deterministic builds** with pinned, SHA-verified binaries (Power variant)
- **Kubernetes helpers** (`kubectx`, `kubens`) built-in

---

## Security

### Reporting Vulnerabilities

See [`SECURITY.md`](SECURITY.md) for the security policy and reporting process.

### Security Scanning

Every release is scanned with Trivy. Builds fail on HIGH/CRITICAL vulnerabilities.

### Design Considerations

- **Runs as root:** By design (debugging tool, not production workload)
- **No secrets baked in:** Only open-source debugging tools
- **Minimal attack surface:** Lite variant excludes compilers and scripting runtimes

---

## License

MIT License. See [`LICENSE`](LICENSE) for full text.

---

## Maintainer

DebugBox is maintained by [Muhammad Ibtisam](https://github.com/ibtisam-iq).

This project prioritizes engineering clarity over feature accumulation. Every tool addition is evaluated for:
- Genuine debugging value
- Image size impact
- Maintenance burden
- Overlap with existing tools

---

## Acknowledgments

Inspired by:
- Real-world CKA/CKAD preparation challenges
- Production troubleshooting workflows requiring deterministic tooling
