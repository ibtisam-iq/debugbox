# Balanced Variant (Recommended)

**~48 MB** — The sweet spot for daily debugging.

The **balanced** variant is the **default** and recommended choice for nearly all troubleshooting tasks.

## When to Use Balanced

Ideal for:

- Debugging running application pods (`kubectl debug`)
- Daily Kubernetes workflows
- Process, network, and system inspection
- When you're unsure — start here

**Upgrade to power** only if you need packet analysis or advanced routing tools.

## Key Additions Over Lite

| Category          | Tools Added                                      |
|-------------------|--------------------------------------------------|
| Shell & UX        | `bash` + completion, `less`                      |
| Editors           | `vim`                                            |
| Networking        | `tcpdump`, `socat`, `nmap`, `mtr`, `iperf3`, `ethtool`, `iftop` |
| System            | `htop`, `strace`, `lsof`, `procps`, `psmisc`     |
| Kubernetes        | `kubectx`, `kubens`                              |
| Filesystem/VCS    | `git`, `file`, `tar`, `gzip`                     |

→ Full details: **[Tooling Manifest](../reference/manifest.md)**

## Example Usage

```bash
# Most common: debug a running pod
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox

# Or standalone session
kubectl run debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never
```

Inside:
```bash
kubens monitoring
tcpdump -i eth0 port 8080 -c 10
strace -p 1234
htop
vim /tmp/log.txt
```

## Image Details

- Compressed size: ~48 MB
- Architectures: `linux/amd64`, `linux/arm64`
- **Default image**: `ghcr.io/ibtisam-iq/debugbox` → balanced

Pull:
```bash
ghcr.io/ibtisam-iq/debugbox:latest
```

## Navigation

← **[Lite Variant](lite.md)** | **[Variants Overview](overview.md)** | **[Power Variant](power.md)** →
