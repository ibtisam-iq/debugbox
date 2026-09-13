# Power Variant

**~91 MB**: Full SRE-grade forensics toolkit.

Everything from balanced, plus advanced tools for deep system and network investigation.

## When to Use Power

- Detailed packet analysis with tshark
- Port scanning and service discovery with nmap
- Network performance testing with iperf3
- Library-level tracing (ltrace)
- Advanced routing and firewall debugging
- Deep incident forensics
- **Not recommended for routine tasks. Stick with balanced to save bandwidth**

## Linux Capabilities Required

Power variant tools like `tshark`, `conntrack`, `iptables`, and `nftables` require **additional Linux capabilities** to function.

→ **[Kubernetes capability setup](../usage/kubernetes.md#power-variant-with-capabilities)**
→ **[Docker capability setup](../usage/docker.md#power-variant-with-capabilities)**

## Quick Usage

```bash
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:power
```

For tools that require capabilities (tshark, conntrack, iptables), use a manifest:

```bash
kubectl apply -f \
  https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/power-debug-pod.yaml
kubectl wait pod/debug-power --for=condition=Ready --timeout=60s
kubectl exec -it debug-power -- bash -l
```

→ **[All tag formats](../reference/tags.md)** | **[Kubernetes usage](../usage/kubernetes.md)** | **[Docker usage](../usage/docker.md)**

## What's Included

Power includes **all balanced tools** plus advanced forensics packages for packet analysis, network scanning, and routing inspection.

→ **[Complete tool list](../reference/manifest.md)** | **[Usage examples](../guides/examples.md)**

**Key additions over balanced:**

- **Packet Analysis:** tshark, ngrep (requires NET_RAW)
- **Network Scanning:** nmap, nmap-nping, nmap-scripts
- **Network Performance:** iperf3, ethtool, iftop
- **Routing & Firewall:** iptables, nftables, conntrack (requires NET_ADMIN)
- **Advanced Network:** tcptraceroute, fping
- **System Internals:** ltrace

## Shell Helpers

Power includes **all balanced helpers** plus **1 additional helper**:

→ **[Complete shell helper reference with examples](../guides/examples.md#helper-functions-shell)**

**Power-exclusive helper:**

- `conntrack-watch()`: List active conntrack entries (requires NET_ADMIN)

## When to Downgrade

**Most tasks use [Balanced Variant](balanced.md).** Downgrade to save ~44 MB.

**For speed, use [Lite Variant](lite.md).** Saves ~76 MB.

→ **[Variants Overview](overview.md)** | **[Real-world Examples](../guides/examples.md)** | **[Troubleshooting](../guides/troubleshooting.md)**
