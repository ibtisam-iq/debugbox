# Power Variant

**~112 MB** -- Full SRE-grade forensics toolkit.

Everything from balanced, plus advanced tools for deep system and network investigation.

## When to Use Power

- Detailed packet analysis with tshark
- Port scanning and service discovery with nmap
- Network performance testing with iperf3
- Library-level tracing (ltrace)
- Advanced routing and firewall debugging
- Deep incident forensics
- **Not recommended for routine tasks. Stick with balanced to save bandwidth**

## ⚠️ Linux Capabilities Required

Power variant tools like `tshark`, `conntrack`, `iptables`, and `nftables` require **additional Linux capabilities** to function.

→ **[Kubernetes capability setup](../usage/kubernetes.md#power-variant-with-capabilities)**
→ **[Docker capability setup](../usage/docker.md#power-variant-with-capabilities)**

## Pull Tags

**Latest:**
```bash
ghcr.io/ibtisam-iq/debugbox:power
ghcr.io/ibtisam-iq/debugbox:power-latest
```

**Production (pinned version):**
```bash
ghcr.io/ibtisam-iq/debugbox:power-1.0.0
```

## Quick Usage

### Kubernetes

**With capabilities (recommended for advanced tools):**
```bash
# Apply pre-made manifest
kubectl apply -f \
  https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/power-debug-pod.yaml

kubectl exec -it debug-power -- bash
```

**Basic usage (no capabilities):**
```bash
kubectl debug my-pod -it \
  --image=ghcr.io/ibtisam-iq/debugbox:power

kubectl run debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox:power --restart=Never
```

### Docker

**With capabilities:**
```bash
docker run --rm -it \
  --cap-add=NET_ADMIN \
  --cap-add=NET_RAW \
  ghcr.io/ibtisam-iq/debugbox:power
```

**Basic usage:**
```bash
docker run -it ghcr.io/ibtisam-iq/debugbox:power
docker run -it ghcr.io/ibtisam-iq/debugbox:power-1.0.0  # Production
```

## What's Included

Power includes **all balanced tools** plus advanced forensics packages for packet analysis, network scanning, and routing inspection.

→ **[Complete power tool list with examples](../guides/examples.md#variant-power-112-mb-full-forensics)**

**Key additions over balanced:**

- **Packet Analysis:** tshark, ngrep (requires NET_RAW)
- **Network Scanning:** nmap, nmap-nping, nmap-scripts
- **Network Performance:** iperf3, ethtool, iftop
- **Routing & Firewall:** iptables, nftables, conntrack (requires NET_ADMIN)
- **Advanced Network:** tcptraceroute, fping
- **System Internals:** ltrace

## Shell Helpers

Power includes **all balanced helpers** plus **1 additional function**:

→ **[Complete shell helper reference with examples](../guides/examples.md#helper-functions-shell)**

**Power-exclusive helper:**

- `conntrack-watch` -- Monitor active connections in real-time (requires NET_ADMIN)

## When to Downgrade

**Most tasks use [Balanced Variant](balanced.md).** Downgrade to save ~61 MB.

**For speed, use [Lite Variant](lite.md).** Saves ~97 MB.

→ **[Variants Overview](overview.md)** | **[Real-world Examples](../guides/examples.md)** | **[Troubleshooting](../guides/troubleshooting.md)**
