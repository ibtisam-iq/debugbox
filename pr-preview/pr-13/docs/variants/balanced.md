# Balanced Variant (Recommended)

**~47 MB** -- The default for daily debugging.

The default and recommended choice for nearly all Kubernetes troubleshooting tasks.

## When to Use Balanced

- Debugging running application pods
- Daily Kubernetes workflows and incident response
- Process tracing, network inspection, system diagnostics
- **When in doubt, start here**

## Quick Usage

```bash
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox
```

Balanced is the default -- no variant tag needed.

→ **[All tag formats](../reference/tags.md)** | **[Kubernetes usage](../usage/kubernetes.md)** | **[Docker usage](../usage/docker.md)**

## What's Included

Balanced includes **all lite tools** plus additional packages for system debugging, process inspection, TLS inspection, and Kubernetes workflows.

→ **[Complete tool list](../reference/manifest.md)** | **[Usage examples](../guides/examples.md)**

**Key additions over lite:**

- **Shell & Editors:** bash, vim, less
- **TLS/SSL:** openssl (certificate inspection, TLS debugging)
- **Process Tools:** strace, lsof, htop, ps, top
- **Network Advanced:** tcpdump, socat, mtr
- **Kubernetes Helpers:** kubectx, kubens
- **Version Control:** git
- **Compression:** tar, gzip

## Shell Helpers

Balanced includes **10 custom shell helpers** for rapid debugging:

→ **[Complete shell helper reference with examples](../guides/examples.md#helper-functions-shell)**

**Quick reference:**

- `json()` / `yaml()` -- Pretty-print data
- `ports` / `connections` -- Socket inspection
- `routes` -- Display routing table
- `k8s-info` -- Current Kubernetes context
- `sniff` / `sniff-http` / `sniff-dns` -- Packet capture shortcuts
- `cert-check()` -- TLS certificate inspection

## When to Switch

**Downgrade to [Lite Variant](lite.md)?** Save ~32 MB if you only need basic connectivity.

**Upgrade to [Power Variant](power.md)?** Need packet analysis, network scanning, or routing tools.

→ **[Variants Overview](overview.md)** | **[Real-world Examples](../guides/examples.md)** | **[Troubleshooting](../guides/troubleshooting.md)**
