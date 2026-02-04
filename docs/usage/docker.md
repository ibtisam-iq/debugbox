# Docker Usage

DebugBox integrates seamlessly with Docker for local development and container inspection.

## Interactive Session

```bash
# Latest balanced (default)
docker run -it --rm ghcr.io/ibtisam-iq/debugbox

# Specific variant
docker run -it --rm ghcr.io/ibtisam-iq/debugbox:lite
docker run -it --rm ghcr.io/ibtisam-iq/debugbox:power

# Production (pinned version)
docker run -it --rm ghcr.io/ibtisam-iq/debugbox:1.0.0
docker run -it --rm ghcr.io/ibtisam-iq/debugbox:lite-1.0.0
```

## Power Variant with Capabilities

**⚠️ For advanced networking tools** (`tshark`, `conntrack`, `nft`, `iptables`), add Linux capabilities:

```bash
docker run --rm -it \
  --cap-add=NET_ADMIN \
  --cap-add=NET_RAW \
  ghcr.io/ibtisam-iq/debugbox:power
```

**What each capability enables:**

- `NET_ADMIN` — conntrack, nft, iptables, ip route manipulation
- `NET_RAW` — tshark, tcpdump, raw packet capture

## Share Another Container's Network

Inspect another container's network namespace:

```bash
docker run -it --rm \
  --net container:my-app \
  ghcr.io/ibtisam-iq/debugbox
```

## Host Network Access

Debug the Docker host directly:

```bash
docker run -it --rm --net host ghcr.io/ibtisam-iq/debugbox
```

## Volume Mount for Artifacts

Save packet captures or logs to host:

```bash
docker run -it --rm \
  -v $(pwd)/captures:/captures \
  --cap-add=NET_RAW \
  ghcr.io/ibtisam-iq/debugbox:power

# Inside
tshark -i eth0 -w /captures/traffic.pcap
```

## Docker Compose Sidecar

Add a debugging sidecar to your compose file:

### Standard Debugging
```yaml
services:
  app:
    image: nginx:alpine
    ports: ["80:80"]

  debugbox:
    image: ghcr.io/ibtisam-iq/debugbox:balanced
    network_mode: service:app
    command: sleep infinity
    tty: true
```

### With Networking Capabilities (Power Variant)
```yaml
services:
  app:
    image: nginx:alpine
    ports: ["80:80"]

  debugbox-power:
    image: ghcr.io/ibtisam-iq/debugbox:power
    network_mode: service:app
    command: sleep infinity
    cap_add:
      - NET_ADMIN
      - NET_RAW
    tty: true
```

Access:
```bash
# Standard
docker compose exec debugbox bash

# Power with capabilities
docker compose exec debugbox-power bash
```

## Variant Selection Guide

| Task | Variant | Command |
|------|---------|------------|
| Quick connectivity test | lite | `docker run -it --rm ghcr.io/ibtisam-iq/debugbox:lite` |
| General debugging | balanced | `docker run -it --rm ghcr.io/ibtisam-iq/debugbox` |
| Packet capture | power + caps | `docker run -it --rm --cap-add=NET_RAW ghcr.io/ibtisam-iq/debugbox:power` |
| Firewall/routing | power + caps | `docker run -it --rm --cap-add=NET_ADMIN ghcr.io/ibtisam-iq/debugbox:power` |

→ **[Kubernetes Usage](kubernetes.md)** | **[Real-world examples](../guides/examples.md)** | **[Troubleshooting](../guides/troubleshooting.md)**
