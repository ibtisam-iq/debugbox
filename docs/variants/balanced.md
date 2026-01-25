# Balanced Variant

48 MB variant. **This is the recommended variant for most use cases.**

## Use Cases

- General Kubernetes troubleshooting
- Debugging live application pods
- Daily debugging workflows
- Default choice when unsure

## What's Included

Includes all lite tools, plus:

### Shell & UX
- `bash` — Full shell with completion
- `less` — Pager

### Editors
- `vim` — Text editor

### Network Tools
- `tcpdump` — Packet capture
- `socat` — Socket relay
- `nmap` — Network scanning
- `mtr` — Traceroute with live stats
- `iperf3` — Network performance testing
- `ethtool` — Network interface config
- `iftop` — Bandwidth monitoring

### System Tools
- `htop` — Process monitoring
- `strace` — System call tracing
- `lsof` — Open file inspector
- `procps` — Process utilities
- `psmisc` — Process tools

### Kubernetes Tools
- `kubectx` — Switch contexts easily
- `kubens` — Switch namespaces easily

### Other
- `git` — Version control
- `file` — File type detection
- `tar`, `gzip` — Archive tools

## Example Usage

```bash
# Debug running pod
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox

# Temporary debugging pod
kubectl run debugbox --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never
```

Inside the container:

```bash
# Switch to different namespace
kubens kube-system

# Check pod logs and trace
strace -p <pid>

# Inspect network connections
netstat -tulpn

# Capture traffic
tcpdump -i eth0 -c 10
```

## Size

- **Compressed:** 48 MB
- **Uncompressed:** ~150 MB

## When to Upgrade

Move to **power** if you need:
- Packet analysis (tshark)
- Deep system tracing (ltrace)
- Routing/firewall (iptables, nftables)
- Advanced scripting (Python/pip3)
