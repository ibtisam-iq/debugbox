# Tooling Manifest

The **authoritative** list of tools, shell behavior, and environment guarantees in each DebugBox variant.

This page is derived from the source-of-truth [`manifest.yaml`](../manifest.yaml) in the repository.

All variants run as **root** by design (required for debugging privileges).

## Variant Inheritance

- **lite** → builds on base
- **balanced** → builds on lite
- **power** → builds on balanced

Tools marked with ✓ are included in that variant and all higher tiers.

## Tools by Category

### Shell & Environment

| Feature                  | Base | Lite | Balanced | Power | Notes                                      |
|--------------------------|------|------|----------|-------|--------------------------------------------|
| Default shell            | ash  | ash  | **bash** | bash  | Balanced+ include bash-completion          |
| Prompt                   | ✓    | ✓    | ✓        | ✓     | `[debugbox \w]$`                           |
| Editor (default)         | vi   | vi   | **vim**  | vim   | nano added in power                        |
| Pager                    | —    | —    | **less** | less  |                                            |
| Locale                   | ✓    | ✓    | ✓        | ✓     | `C.UTF-8`                                  |

### Shell Helpers (/etc/profile.d)

| Helper     | Base | Lite | Balanced | Power | Description                          |
|------------|------|------|----------|-------|--------------------------------------|
| `ll()`     | ✓    | ✓    | ✓        | ✓     | `ls -alF` alias                      |
| `json()`   | —    | ✓    | ✓        | ✓     | Pretty-print JSON with jq            |
| `yaml()`   | —    | ✓    | ✓        | ✓     | Pretty-print YAML with yq            |
| `sniff()`  | —    | —    | —        | ✓     | Quick tcpdump wrapper (power only)   |

### Networking

| Tool              | Lite | Balanced | Power | Notes                                      |
|-------------------|------|----------|-------|--------------------------------------------|
| curl              | ✓    | ✓        | ✓     |                                            |
| netcat-openbsd    | ✓    | ✓        | ✓     |                                            |
| iproute2 (`ip`)   | ✓    | ✓        | ✓     |                                            |
| iputils (`ping`)  | ✓    | ✓        | ✓     |                                            |
| bind-tools (`dig`, `nslookup`) | ✓    | ✓        | ✓     |                                            |
| tcpdump           | —    | ✓        | ✓     |                                            |
| socat             | —    | ✓        | ✓     |                                            |
| nmap              | —    | ✓        | ✓     |                                            |
| mtr               | —    | ✓        | ✓     |                                            |
| iperf3            | —    | ✓        | ✓     |                                            |
| ethtool           | —    | ✓        | ✓     |                                            |
| iftop             | —    | ✓        | ✓     |                                            |
| tshark            | —    | —        | ✓     | Wireshark CLI                              |
| fping             | —    | —        | ✓     |                                            |
| speedtest-cli     | —    | —        | ✓     |                                            |
| nmap-nping        | —    | —        | ✓     |                                            |
| nmap-scripts      | —    | —        | ✓     | NSE scripts                                |

### System & Process

| Tool              | Lite | Balanced | Power | Notes                                      |
|-------------------|------|----------|-------|--------------------------------------------|
| htop              | —    | ✓        | ✓     |                                            |
| strace            | —    | ✓        | ✓     |                                            |
| lsof              | —    | ✓        | ✓     |                                            |
| procps            | —    | ✓        | ✓     |                                            |
| psmisc            | —    | ✓        | ✓     |                                            |
| ltrace            | —    | —        | ✓     | Library call tracing                       |

### Kubernetes & Control Plane

| Tool              | Lite | Balanced | Power | Notes                                      |
|-------------------|------|----------|-------|--------------------------------------------|
| kubectx           | —    | ✓        | ✓     | Context switching                          |
| kubens            | —    | ✓        | ✓     | Namespace switching                        |

### Data Processing & Scripting

| Tool              | Lite | Balanced | Power | Notes                                      |
|-------------------|------|----------|-------|--------------------------------------------|
| jq                | ✓    | ✓        | ✓     | JSON processing                            |
| yq                | ✓    | ✓        | ✓     | Lite/Balanced: Alpine package<br>Power: pinned v4.x binary (SHA-verified) |
| python3 + pip3    | —    | —        | ✓     | Ad-hoc scripting                           |

### Filesystem & Version Control

| Tool              | Lite | Balanced | Power |
|-------------------|------|----------|------|
| file              | —    | ✓        | ✓    |
| tar, gzip         | —    | ✓        | ✓    |
| git               | —    | ✓        | ✓    |

### Routing & Firewall (Power Only)

| Tool              | Power |
|-------------------|-------|
| iptables          | ✓     |
| nftables          | ✓     |
| conntrack-tools   | ✓     |
| bird              | ✓     |
| bridge-utils      | ✓     |

## Guarantees

- **Deterministic**: Critical tools (e.g., `yq` in power) are version-pinned and SHA-verified
- **Transparent**: Only documented tools are included — no hidden packages
- **Secure by default**: Scanned with Trivy on every release
- **Root access**: All images run as root for full debugging capability (ephemeral use only)

## Source of Truth

The raw manifest is maintained in [`manifest.yaml`](../manifest.yaml).  
Any discrepancy between this page and the YAML file should be reported as a bug.

→ Back to **[Variants Overview](../variants/overview.md)** | **[Examples](../guides/examples.md)** →
