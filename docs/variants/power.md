# Power Variant

110 MB variant with full SRE-grade tooling.

## Use Cases

- Deep network forensics
- Packet capture and analysis
- Routing and firewall debugging
- Complex system troubleshooting
- Performance analysis

## What's Included

Includes all balanced tools, plus:

### Editors
- `nano` — Alternative editor

### Network Forensics
- `tshark` — Wireshark CLI for packet analysis
- `fping` — Fast ping tool
- `speedtest-cli` — Internet speed testing
- `nmap-nping` — Advanced ping
- `nmap-scripts` — NSE scripts

### System Internals
- `ltrace` — Library call tracing

### Routing & Firewall
- `iptables` — Packet filtering
- `nftables` — Modern firewall
- `conntrack-tools` — Connection tracking
- `bird` — BGP/OSPF daemon
- `bridge-utils` — Bridge tools

### Scripting
- `python3` with `pip3` — Python scripting

### Tools
- `yq` — YAML parser (v4.x pinned binary with SHA verification, not Alpine package)

## Example Usage

```bash
kubectl run debugbox-power --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-power \
  --restart=Never
```

Inside the container:

```bash
# Interactive packet analysis
tshark -i eth0 -f "port 443"

# Detailed packet capture
tcpdump -i eth0 -w /tmp/capture.pcap port 443

# Check routing table
ip route
bird -P -d

# Advanced firewall inspection
iptables -L -v -n
nftables list ruleset

# Connection state inspection
conntrack -L
```

## Size

- **Compressed:** 110 MB
- **Uncompressed:** ~350 MB

## When to Use Power

This variant is for when you need to:
- Capture and analyze packets in detail
- Debug complex routing scenarios
- Trace system calls at the library level
- Run custom scripts for advanced analysis
