# Balanced Variant (Recommended)

**~46 MB** — The sweet spot for daily debugging.

The default and recommended choice for nearly all Kubernetes troubleshooting tasks.

## When to Use Balanced

- Debugging running application pods
- Daily Kubernetes workflows and incident response
- Process tracing, network inspection, system diagnostics
- **When in doubt, start here**

## Pull Tags

**Latest:**
```bash
ghcr.io/ibtisam-iq/debugbox              # Most common
ghcr.io/ibtisam-iq/debugbox:latest
ghcr.io/ibtisam-iq/debugbox:balanced
```

**Production (pinned version):**
```bash
ghcr.io/ibtisam-iq/debugbox:1.0.0           # Short form (recommended)
ghcr.io/ibtisam-iq/debugbox:balanced-1.0.0  # Explicit form
```

## Quick Usage

### Kubernetes (Most Common)
```bash
# Default — balanced variant
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox

# Explicit tag
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:balanced

# Standalone
kubectl run debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never
```

### Docker
```bash
docker run -it ghcr.io/ibtisam-iq/debugbox
docker run -it ghcr.io/ibtisam-iq/debugbox:1.0.0  # Production
```

## What's Included

Balanced includes **all lite tools** plus **21 additional packages** for system debugging, process inspection, and Kubernetes workflows.

→ **[Complete balanced tool list with examples](../guides/examples.md#variant-balanced-46-mb-default)**

**Key additions over lite:**

- **Shell & Editors:** bash, vim, nano
- **Process Tools:** strace, lsof, htop, ps, top
- **Network Advanced:** tcpdump, socat, nmap, mtr, iperf3, iftop
- **Kubernetes Helpers:** kubectx, kubens
- **Version Control:** git
- **Compression:** tar, gzip

## Shell Helpers

Balanced includes **6+ custom shell functions** for rapid debugging:

→ **[Complete shell helper reference with examples](../guides/examples.md#helper-functions-shell)**

**Quick reference:**

- `ll()` — `ls -alF` alias
- `json()` / `yaml()` — Pretty-print data
- `ports()` — List listening ports
- `connections()` — Show active connections
- `routes()` — Display routing table
- `k8s-info` — Current Kubernetes context

## When to Switch

**Downgrade to [Lite Variant](lite.md)?** Save 32 MB if you only need basic connectivity.

**Upgrade to [Power Variant](power.md)?** Need packet analysis, routing tools, or scripting.

→ **[Variants overview](overview.md)** | **[Real-world examples](../guides/examples.md)** | **[Troubleshooting](../guides/troubleshooting.md)**
