# Lite Variant

15 MB variant optimized for minimal size and fast pulls.

## Use Cases

- Quick network diagnostics
- DNS resolution checks
- Fast pod startup
- Resource-constrained environments
- Init container debugging

## What's Included

### Network Tools
- `curl` — HTTP requests
- `netcat-openbsd` — TCP/UDP debugging
- `iproute2` — IP routing and network configuration
- `iputils` — ping, traceroute
- `bind-tools` — dig, nslookup

### Data Tools
- `jq` — JSON parsing
- `yq` — YAML parsing (Alpine package, v3.x)

### Shell
- `ash` (BusyBox) — Lightweight shell

## Example Usage

```bash
kubectl run debugbox-lite --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-lite \
  --restart=Never
```

Inside the container:

```bash
# Quick DNS check
dig kubernetes.default.svc.cluster.local

# Connectivity test
curl -I https://kubernetes.io

# Route inspection
ip route
```

## Size

- **Compressed:** 15 MB
- **Uncompressed:** ~50 MB

## When to Upgrade

Move to **balanced** if you need:
- bash shell
- Packet captures (tcpdump)
- Process inspection (strace, lsof)
- Text editors (vim)
- Kubernetes helpers (kubectx)
