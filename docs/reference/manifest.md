# Tooling Manifest

The authoritative source of tools included in each DebugBox variant.

This file documents the **user-visible contract** for each variant. It defines exactly what tools, helpers, and environment guarantees are provided.

For the complete manifest including all details, see the [`docs/manifest.yaml`](../manifest.yaml) file in the repository.

## Base (All Variants)

All variants inherit these tools and behaviors:

### System
- ca-certificates
- locale: C.UTF-8

### Shell
- ash (BusyBox)
- Prompt: `[debugbox \w]$`
- Editor: vi

### Helpers
- `ll()` — Alias for `ls -alF`

---

## Lite Variant

### Networking
- curl
- netcat-openbsd
- iproute2
- iputils (ping, traceroute)
- bind-tools (dig, nslookup)

### Data Tools
- jq — JSON parsing
- yq — YAML parsing (Alpine package, v3.x)

### Shell
- ash (BusyBox)
- Helpers: `json()`, `yaml()`

---

## Balanced Variant

Includes all lite tools, plus:

### Shell & UX
- bash with completion
- less — Pager
- Editor: vim

### Network Tools
- tcpdump — Packet capture
- socat — Socket relay
- nmap — Network scanning
- mtr — Traceroute with stats
- iperf3 — Network performance testing
- ethtool — Network interface configuration
- iftop — Bandwidth monitoring

### System Tools
- htop — Process monitoring
- strace — System call tracing
- lsof — Open files inspector
- procps — Process utilities
- psmisc — Process signals/named pipes

### Kubernetes
- kubectl — Already in base
- kubectx — Switch contexts
- kubens — Switch namespaces

### Other
- git — Version control
- file — File type detection
- tar, gzip — Archive tools

### Shell
- bash with completion
- Helpers: `json()`, `yaml()`

---

## Power Variant

Includes all balanced tools, plus:

### Editors
- nano — Text editor

### Network Forensics
- tshark — Wireshark CLI
- fping — Fast ping
- speedtest-cli — Internet speed test
- nmap-nping — Advanced ping
- nmap-scripts — NSE scripts

### System Internals
- ltrace — Library call tracing

### Routing & Firewall
- iptables — Packet filtering
- nftables — Modern firewall
- conntrack-tools — Connection tracking
- bird — BGP/OSPF routing daemon
- bridge-utils — Bridge management

### Scripting
- python3 with pip3 — Python scripting

### Tools
- yq — YAML parser (v4.x binary, SHA-verified, not Alpine package)

### Shell
- bash with completion
- Helpers: `json()`, `yaml()`, `sniff()`

---

## Guarantees

For each variant:

- ✅ **Version pinning:** Critical binaries are pinned
- ✅ **SHA verification:** Power variant yq is SHA-verified
- ✅ **Documentation:** All tools listed here are documented and intentional
- ✅ **No hidden packages:** Only what's documented is included
- ✅ **Root user:** All images run as root (debugging tool design)

---

## Updates

This manifest is updated whenever tools are added, removed, or upgraded. See [CHANGELOG.md](https://github.com/ibtisam-iq/debugbox/blob/main/CHANGELOG.md) for version history.
