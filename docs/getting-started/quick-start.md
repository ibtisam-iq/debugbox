# Quick Start

Get started with DebugBox in seconds.

## Installation

### GitHub Container Registry (Recommended)

```bash
# Default (balanced variant)
docker pull ghcr.io/ibtisam-iq/debugbox:latest

# Specific variants
docker pull ghcr.io/ibtisam-iq/debugbox-lite:latest
docker pull ghcr.io/ibtisam-iq/debugbox-power:latest
```

### Docker Hub

```bash
docker pull mibtisam/debugbox:latest
docker pull mibtisam/debugbox-lite:latest
docker pull mibtisam/debugbox-power:latest
```

## Kubernetes Usage

### Debug Running Pod

```bash
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox
```

### Temporary Debugging Pod

```bash
kubectl run debugbox --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never
```

### Host Network Debugging

```bash
kubectl run debugbox --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --overrides='{"spec":{"hostNetwork":true}}' \
  --restart=Never
```

## Docker Usage

### Interactive Shell

```bash
docker run -it --rm ghcr.io/ibtisam-iq/debugbox
```

### Debug Another Container's Network

```bash
docker run -it --rm \
  --net container:my-app-container \
  ghcr.io/ibtisam-iq/debugbox
```

### Host Network

```bash
docker run -it --rm \
  --net host \
  ghcr.io/ibtisam-iq/debugbox
```

## Which Variant?

Choose based on your needs:

| Need | Variant | Command |
|------|---------|---------|
| Quick DNS/network check | lite | `--image=ghcr.io/ibtisam-iq/debugbox-lite` |
| General troubleshooting | balanced | `--image=ghcr.io/ibtisam-iq/debugbox` |
| Packet capture/forensics | power | `--image=ghcr.io/ibtisam-iq/debugbox-power` |

When in doubt, use **balanced** (default).

## Next Steps

- Explore [common workflows](../usage/workflows.md)
- Read about [all variants](../variants/overview.md)
- Check the [tooling manifest](../reference/manifest.md)
