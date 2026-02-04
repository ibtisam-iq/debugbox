# Lite Variant

**~14 MB** — Minimal and lightning-fast.

Perfect for quick network diagnostics and bandwidth-constrained environments.

## When to Use Lite

- Quick DNS resolution checks
- API connectivity verification
- Bandwidth-constrained networks or edge clusters
- Init containers or fast pod startup
- When you only need basic networking tools

## Pull Tags

**Latest:**
```bash
ghcr.io/ibtisam-iq/debugbox:lite
ghcr.io/ibtisam-iq/debugbox:lite-latest
```

**Production (pinned version):**
```bash
ghcr.io/ibtisam-iq/debugbox:lite-1.0.0
```

## Quick Usage

### Kubernetes
```bash
# Debug pod with lite variant
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:lite

# Standalone session
kubectl run debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox:lite --restart=Never
```

### Docker
```bash
docker run -it ghcr.io/ibtisam-iq/debugbox:lite
docker run ghcr.io/ibtisam-iq/debugbox:lite curl https://ibtisam-iq.com
```

## What's Included

Lite includes **8 essential networking packages** optimized for fast pulls and basic connectivity testing.

→ **[Complete lite tool list with examples](../guides/examples.md#variant-lite-14-mb)**

**Key categories:**

- HTTP/HTTPS clients (curl)
- DNS tools (dig, nslookup, host)
- Data processors (jq, yq)
- Basic networking (netcat, ip, ping)
- Minimal shell (ash, vi)

## When to Upgrade

**Need more tools?** → **[Balanced Variant](balanced.md)** adds bash, tcpdump, vim, strace, and Kubernetes helpers (+32 MB)

**Need forensics?** → **[Power Variant](power.md)** adds packet analysis, routing, and Python scripting (+90 MB)

→ **[Variants Overview](overview.md)** | **[Real-world examples](../guides/examples.md)** | **[Troubleshooting](../guides/troubleshooting.md)**
