# Lite Variant

**~15 MB** — Minimal and lightning-fast.

The **lite** variant is optimized for scenarios where pull speed and image size matter most.

## When to Use Lite

Perfect for:

- Quick network or DNS checks during incidents
- Ephemeral debugging in bandwidth-constrained environments
- Init containers or fast pod startup
- When you only need basic connectivity tools

**Avoid lite** if you need `tcpdump`, `strace`, `vim`, or Kubernetes context switching.

## Key Tools

| Category     | Tools                                      |
|--------------|--------------------------------------------|
| Networking   | `curl`, `netcat-openbsd`, `iproute2`, `iputils`, `bind-tools` (dig, nslookup) |
| Data         | `jq`, `yq` (Alpine package)                |
| Shell        | `ash` (BusyBox)                            |

→ Full details: **[Tooling Manifest](../reference/manifest.md)**

## Example Usage

```bash
kubectl run debug-lite --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-lite \
  --restart=Never
```

Inside:
```bash
curl -I https://kubernetes.io
dig kubernetes.default.svc.cluster.local
ip route
jq . < config.json
yq '.metadata.name' config.yaml
```

## Image Details

- Compressed size: ~15 MB
- Architectures: `linux/amd64`, `linux/arm64`

Pull:
```bash
ghcr.io/ibtisam-iq/debugbox-lite:latest
```

## Navigation

→ **[Balanced Variant (recommended)](balanced.md)** | **[Variants Overview](overview.md)** →
