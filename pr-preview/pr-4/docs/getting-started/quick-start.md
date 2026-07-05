# Quick Start

Get debugging in seconds.

## Debug a Running Pod (Most Common)

```bash
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox
```

Attaches an ephemeral debugging container with the same network/process namespace as your pod.

## Standalone Debugging Session

```bash
kubectl run debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never
```

## Choose the Right Variant

| Need | Variant | Image |
|------|---------|-------|
| Quick DNS/connectivity | lite | `ghcr.io/ibtisam-iq/debugbox:lite` |
| General troubleshooting (recommended) | balanced | `ghcr.io/ibtisam-iq/debugbox` |
| Packet capture & forensics | power | `ghcr.io/ibtisam-iq/debugbox:power` |

**When in doubt, use balanced** — it's the default.

## What Can I Do Inside?

Once inside the container, you have access to comprehensive debugging tools:

→ **[Complete tool list with examples](../guides/examples.md)**

**Quick examples:**
```bash
# Network testing
curl -I https://ibtisam-iq.com
dig kubernetes.default.svc.cluster.local

# Process inspection
ps aux
htop

# Network monitoring
tcpdump -i eth0 port 443 -c 5

# File editing
vim /tmp/debug.log
```

## Next Steps

→ **[Installation](installation.md)** | **[Variants Overview](../variants/overview.md)** | **[Real-world Examples](../guides/examples.md)**
