# Quick Start

Get debugging in seconds.

## Debug a Running Pod (Most Common)

```bash
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox
```

This attaches an **ephemeral debugging container** (balanced variant) with the same network/process namespace as your pod.

## Standalone Debugging Session

```bash
kubectl run debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never
```

## Inside the Container

You now have access to:

```bash
curl https://example.com
dig kubernetes.default.svc.cluster.local
tcpdump -i eth0 port 443 -c 5
htop
strace -p 1
vim /etc/hosts
```

## Choose the Right Variant

| Need                          | Variant   | Image Tag                                      |
|-------------------------------|-----------|------------------------------------------------|
| Quick network/DNS check       | **lite**     | `ghcr.io/ibtisam-iq/debugbox-lite`          |
| General troubleshooting       | **balanced** (default) | `ghcr.io/ibtisam-iq/debugbox`     |
| Packet capture / deep forensics | **power**    | `ghcr.io/ibtisam-iq/debugbox-power`       |

**When in doubt, use balanced** — it's the default.

## Next Steps

- **[Installation details →](installation.md)** (registries, tags, multi-arch)
- **[Full variant comparison →](../variants/overview.md)**
- **[Complete tool list →](../reference/manifest.md)**

→ Ready for real scenarios? Check the **[Examples](../guides/examples.md)**
