# Tooling Manifest

The **authoritative** list of tools, shell behavior, and environment guarantees in each DebugBox variant.

This page is derived from the source-of-truth [`manifest.yaml`](https://github.com/ibtisam-iq/debugbox/blob/main/docs/manifest.yaml) in the repository.

All variants run as **root** by design (required for debugging privileges).

## Variant Inheritance

- **lite** -- builds on base
- **balanced** -- builds on lite
- **power** -- builds on balanced

Tools marked with a check are included in that variant and all higher tiers.

## Tools by Category

### Shell & Environment

| Feature | Base | Lite | Balanced | Power |
|---------|------|------|----------|-------|
| Default shell | ash | ash | **bash** | bash |
| Prompt | ✓ | ✓ | ✓ | ✓ |
| Editor (default) | vi | vi | **vim** | vim |
| Pager | -- | -- | **less** | less |
| Locale | C.UTF-8 | C.UTF-8 | C.UTF-8 | C.UTF-8 |

### Shell Helpers (/etc/profile.d)

| Helper | Lite | Balanced | Power | Description |
|--------|------|----------|-------|-------------|
| `ll()` | ✓ | ✓ | ✓ | `ls -alF` alias |
| `json()` | ✓ | ✓ | ✓ | Pretty-print JSON |
| `yaml()` | ✓ | ✓ | ✓ | Pretty-print YAML |
| `ports` | -- | ✓ | ✓ | List listening ports |
| `connections` | -- | ✓ | ✓ | Show all connections |
| `routes` | -- | ✓ | ✓ | Display routing table |
| `k8s-info` | -- | ✓ | ✓ | K8s context & namespace |
| `sniff` | -- | ✓ | ✓ | Quick packet capture |
| `sniff-http` | -- | ✓ | ✓ | Capture HTTP (80/443) |
| `sniff-dns` | -- | ✓ | ✓ | Capture DNS queries |
| `cert-check()` | -- | ✓ | ✓ | Inspect TLS certs |
| `conntrack-watch` | -- | -- | ✓ | Monitor connections |

### Networking

| Tool | Lite | Balanced | Power |
|------|------|----------|-------|
| curl | ✓ | ✓ | ✓ |
| netcat-openbsd | ✓ | ✓ | ✓ |
| iproute2 (ip, ss) | ✓ | ✓ | ✓ |
| iputils (ping, arping, tracepath) | ✓ | ✓ | ✓ |
| bind-tools (dig, nslookup, host) | ✓ | ✓ | ✓ |
| tcpdump | -- | ✓ | ✓ |
| socat | -- | ✓ | ✓ |
| mtr | -- | ✓ | ✓ |
| nmap | -- | -- | ✓ |
| iperf3 | -- | -- | ✓ |
| ethtool | -- | -- | ✓ |
| iftop | -- | -- | ✓ |
| tshark | -- | -- | ✓ |
| ngrep | -- | -- | ✓ |
| tcptraceroute | -- | -- | ✓ |
| fping | -- | -- | ✓ |
| nmap-nping | -- | -- | ✓ |
| nmap-scripts (NSE) | -- | -- | ✓ |

### TLS/SSL

| Tool | Lite | Balanced | Power |
|------|------|----------|-------|
| openssl | -- | ✓ | ✓ |

### System & Process

| Tool | Lite | Balanced | Power |
|------|------|----------|-------|
| htop | -- | ✓ | ✓ |
| strace | -- | ✓ | ✓ |
| lsof | -- | ✓ | ✓ |
| procps (ps, top) | -- | ✓ | ✓ |
| psmisc (pstree, killall, fuser) | -- | ✓ | ✓ |
| ltrace | -- | -- | ✓ |

### Kubernetes & Control Plane

| Tool | Lite | Balanced | Power |
|------|------|----------|-------|
| kubectx | -- | ✓ | ✓ |
| kubens | -- | ✓ | ✓ |

### Data Processing

| Tool | Lite | Balanced | Power |
|------|------|----------|-------|
| jq | ✓ | ✓ | ✓ |
| yq | ✓ (apk) | ✓ (apk) | ✓ (pinned binary) |

**Note on yq:** All variants include [mikefarah/yq](https://github.com/mikefarah/yq) (the Go-based YAML processor), not the Python [kislyuk/yq](https://github.com/kislyuk/yq) wrapper. Lite and balanced install yq from Alpine packages; power uses a version-pinned, SHA-verified binary for reproducibility. The syntax is the same across all variants (`yq '.key' file.yaml`).

### Filesystem & Version Control

| Tool | Lite | Balanced | Power |
|------|------|----------|-------|
| file | -- | ✓ | ✓ |
| tar, gzip | -- | ✓ | ✓ |
| git | -- | ✓ | ✓ |

### Routing & Firewall (Power Only)

| Tool | Power |
|------|-------|
| iptables | ✓ |
| nftables | ✓ |
| conntrack-tools | ✓ |

## Guarantees

- **Deterministic:** Critical tools (e.g., yq in power) are version-pinned and SHA-verified
- **Transparent:** Only documented tools included, no hidden packages
- **Secure by default:** Scanned with Trivy on every release
- **Root access:** All images run as root for full debugging capability (ephemeral use only)

→ **[Variants Overview](../variants/overview.md)** | **[Image Tags](tags.md)** | **[Examples](../guides/examples.md)**
