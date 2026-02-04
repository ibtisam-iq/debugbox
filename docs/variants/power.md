# Power Variant

**~104 MB** — Full SRE-grade forensics toolkit.

Everything from balanced, plus advanced tools for deep system and network investigation.

## When to Use Power

- Detailed packet analysis with tshark
- Library-level tracing (ltrace)
- Advanced routing and firewall debugging
- Custom Python scripting
- Deep incident forensics
- **Not recommended for routine tasks — stick with balanced to save bandwidth**

## ⚠️ Linux Capabilities Required

Power variant tools like `tshark`, `conntrack`, `iptables`, and `nftables` require **additional Linux capabilities** to function:

- **NET_RAW** — For packet capture (tshark, tcpdump, ngrep)
- **NET_ADMIN** — For firewall/routing (iptables, nftables, conntrack, brctl)

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
kubectl apply -f https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/power-debug-pod.yaml
kubectl exec -it debug-power -- bash
```

**Basic usage (no capabilities):**
```bash
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:power
kubectl run debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox:power --restart=Never
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

Power includes **all balanced tools** plus **14 advanced forensics packages** for packet analysis, TLS inspection, routing, and scripting.

→ **[Complete power tool list with examples](../guides/examples.md#variant-power-104-mb-full-forensics)**

**Key additions over balanced:**

- **Packet Analysis:** tshark, ngrep (requires NET_RAW)
- **TLS/SSL:** openssl
- **Routing & Firewall:** iptables, nftables, conntrack, bird, brctl (requires NET_ADMIN)
- **Advanced Network:** tcptraceroute, fping, speedtest-cli, nmap-nping, nmap-scripts
- **System Internals:** ltrace
- **Scripting:** Python 3 + pip3
- **Editors:** nano (in addition to vim)

## Shell Helpers

Power includes **all balanced helpers** plus **4 advanced network functions**:

→ **[Complete shell helper reference with examples](../guides/examples.md#helper-functions-shell)**

**Power-exclusive helpers:**

- `sniff()` — Quick packet capture with smart filters
- `sniff-http()` — Capture HTTP traffic (ports 80/443)
- `sniff-dns()` — Capture DNS queries (port 53)
- `cert-check()` — Inspect TLS certificates from servers
- `conntrack-watch()` — Monitor active connections in real-time

## Tool Capability Matrix

| Tool | Capability Required | Works Without? |
|------|---------------------|----------------|
| openssl, ltrace, python3 | None | ✅ Yes |
| tshark, ngrep | NET_RAW | ❌ No |
| iptables, nftables, conntrack, brctl | NET_ADMIN | ❌ No |
| tcptraceroute, fping, nmap-nping | None | ✅ Yes |

→ **[Detailed capability setup guide](../guides/examples.md#capability-requirements-reference)**

## When to Downgrade

**Most tasks use [Balanced Variant](balanced.md).** Downgrade to save 58 MB.  

**For speed, use [Lite Variant](lite.md).** Saves 90 MB.

→ **[Variants Overview](overview.md)** | **[Real-world examples](../guides/examples.md)** | **[Troubleshooting](../guides/troubleshooting.md)**
