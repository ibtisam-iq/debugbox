# Tooling Manifest

The **authoritative** list of tools, shell behavior, and environment guarantees in each DebugBox variant.

This page is derived from the source-of-truth [`manifest.yaml`](https://github.com/ibtisam-iq/debugbox/blob/main/docs/manifest.yaml) in the repository.

All variants run as **root** by design (required for debugging privileges).

## Variant Inheritance

- **lite** → builds on base
- **balanced** → builds on lite
- **power** → builds on balanced

Tools marked with ✓ are included in that variant and all higher tiers.

## Tools by Category

### Shell & Environment

| Feature | Base | Lite | Balanced | Power |
|---------|------|------|----------|-------|
| Default shell | ash | ash | **bash** | bash |
| Prompt | ✓ | ✓ | ✓ | ✓ |
| Editor (default) | vi | vi | **vim** | vim |
| Additional editor | — | — | — | nano |
| Pager | — | — | **less** | less |
| Locale | C.UTF-8 | C.UTF-8 | C.UTF-8 | C.UTF-8 |

### Shell Helpers (/etc/profile.d)

| Helper | Lite | Balanced | Power | Description |
|--------|------|----------|-------|-------------|
| `ll()` | ✓ | ✓ | ✓ | `ls -alF` alias |
| `json()` | ✓ | ✓ | ✓ | Pretty-print JSON |
| `yaml()` | ✓ | ✓ | ✓ | Pretty-print YAML |
| `ports()` | — | ✓ | ✓ | List listening ports |
| `connections()` | — | ✓ | ✓ | Show active connections |
| `routes()` | — | ✓ | ✓ | Display routing table |
| `k8s-info` | — | ✓ | ✓ | K8s context & namespace |
| `sniff()` | — | — | ✓ | Quick packet capture |
| `sniff-http()` | — | — | ✓ | Capture HTTP (80/443) |
| `sniff-dns()` | — | — | ✓ | Capture DNS queries |
| `cert-check()` | — | — | ✓ | Inspect TLS certs |
| `conntrack-watch()` | — | — | ✓ | Monitor connections |

### Networking

| Tool | Lite | Balanced | Power |
|------|------|----------|-------|
| curl | ✓ | ✓ | ✓ |
| netcat-openbsd | ✓ | ✓ | ✓ |
| iproute2 (ip) | ✓ | ✓ | ✓ |
| iputils (ping) | ✓ | ✓ | ✓ |
| bind-tools (dig, nslookup) | ✓ | ✓ | ✓ |
| tcpdump | — | ✓ | ✓ |
| socat | — | ✓ | ✓ |
| nmap | — | ✓ | ✓ |
| mtr | — | ✓ | ✓ |
| iperf3 | — | ✓ | ✓ |
| ethtool | — | ✓ | ✓ |
| iftop | — | ✓ | ✓ |
| tshark | — | — | ✓ |
| ngrep | — | — | ✓ |
| tcptraceroute | — | — | ✓ |
| fping | — | — | ✓ |
| speedtest-cli | — | — | ✓ |
| nmap-nping | — | — | ✓ |
| nmap-scripts (NSE) | — | — | ✓ |

### System & Process

| Tool | Lite | Balanced | Power |
|------|------|----------|-------|
| htop | — | ✓ | ✓ |
| strace | — | ✓ | ✓ |
| lsof | — | ✓ | ✓ |
| procps | — | ✓ | ✓ |
| psmisc | — | ✓ | ✓ |
| ltrace | — | — | ✓ |

### Kubernetes & Control Plane

| Tool | Lite | Balanced | Power |
|------|------|----------|-------|
| kubectx | — | ✓ | ✓ |
| kubens | — | ✓ | ✓ |

### Data Processing & Scripting

| Tool | Lite | Balanced | Power |
|------|------|----------|-------|
| jq | ✓ | ✓ | ✓ |
| yq | ✓ | ✓ | ✓ |
| python3 + pip3 | — | — | ✓ |

### Filesystem & Version Control

| Tool | Lite | Balanced | Power |
|------|------|----------|-------|
| file | — | ✓ | ✓ |
| tar, gzip | — | ✓ | ✓ |
| git | — | ✓ | ✓ |

### TLS/SSL (Power Only)

| Tool | Power |
|------|-------|
| openssl | ✓ |

### Routing & Firewall (Power Only)

| Tool | Power |
|------|-------|
| iptables | ✓ |
| nftables | ✓ |
| conntrack-tools | ✓ |
| bird | ✓ |
| bridge-utils | ✓ |

## Guarantees

- **Deterministic:** Critical tools (e.g., yq in power) are version-pinned and SHA-verified
- **Transparent:** Only documented tools included — no hidden packages
- **Secure by default:** Scanned with Trivy on every release
- **Root access:** All images run as root for full debugging capability (ephemeral use only)

→ **[Variants Overview](../variants/overview.md)** | **[Image Tags](tags.md)** | **[Examples](../guides/examples.md)**
