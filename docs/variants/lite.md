# Lite Variant

**~15 MB**: Minimal and fast.

Perfect for quick network diagnostics and bandwidth-constrained environments.

## When to Use Lite

- Quick DNS resolution checks
- API connectivity verification
- Bandwidth-constrained networks or edge clusters
- Init containers or fast pod startup
- When you only need basic networking tools

## Quick Usage

```bash
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:lite
```

→ **[All tag formats](../reference/tags.md)** | **[Kubernetes usage](../usage/kubernetes.md)** | **[Docker usage](../usage/docker.md)**

## What's Included

Lite includes **7 focused packages** optimized for fast pulls and basic connectivity testing.

→ **[Complete tool list](../reference/manifest.md)** | **[Usage examples](../guides/examples.md)**

**Key categories:**

- HTTP/HTTPS clients (curl)
- DNS tools (dig, nslookup, host)
- Data processors (jq, yq)
- Basic networking (netcat, ip, ping)
- Minimal shell (ash, vi)

## When to Upgrade

**Need more tools?** → **[Balanced Variant](balanced.md)** adds bash, tcpdump, openssl, vim, strace, and Kubernetes helpers (+~32 MB)

**Need forensics?** → **[Power Variant](power.md)** adds packet analysis, port scanning, and routing tools (+~76 MB)

→ **[Variants Overview](overview.md)** | **[Real-world Examples](../guides/examples.md)** | **[Troubleshooting](../guides/troubleshooting.md)**
