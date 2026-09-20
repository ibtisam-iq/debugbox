# Quick Start

Get debugging in seconds.

!!! tip "Try it in a live Kubernetes environment"
    Step through these commands interactively (no local cluster required):
    **[Kubernetes Debugging with DebugBox →](https://labs.iximiuz.com/tutorials/kubernetes-debugging-with-debugbox-74e481c8)**

## Debug a Running Pod (Most Common)

```bash
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox
```

Attaches an ephemeral debugging container sharing the pod's network namespace.

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

**When in doubt, use balanced.** It's the default.

## Inside the Container

Comprehensive debugging tools are available:

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

## Registries

DebugBox is published to two registries. No authentication required.

| Registry | Pull prefix |
|----------|-------------|
| **GHCR (recommended)** | `ghcr.io/ibtisam-iq/debugbox` |
| **Docker Hub** | `docker.io/mibtisam/debugbox` |

For production, pin versions: `ghcr.io/ibtisam-iq/debugbox:1.2.0`

→ **[Complete tag reference](../reference/tags.md)** | **[Variants Overview](../variants/overview.md)** | **[Real-world Examples](../guides/examples.md)**
