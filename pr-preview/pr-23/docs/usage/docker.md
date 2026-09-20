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
docker run -it --rm ghcr.io/ibtisam-iq/debugbox:1.2.0
docker run -it --rm ghcr.io/ibtisam-iq/debugbox:lite-1.2.0
```

## Power Variant with Capabilities

**Note:** For advanced networking tools (`tshark`, `conntrack`, `nft`, `iptables`), add Linux capabilities:

```bash
docker run --rm -it \
  --cap-add=NET_ADMIN \
  --cap-add=NET_RAW \
  ghcr.io/ibtisam-iq/debugbox:power
```

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
  --cap-add=NET_ADMIN \
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
    image: ghcr.io/ibtisam-iq/ibtisam-iq:latest
    ports: ["8080:8080"]

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
    image: ghcr.io/ibtisam-iq/ibtisam-iq:latest
    ports: ["8080:8080"]

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
docker compose exec debugbox bash -l

# Power with capabilities
docker compose exec debugbox-power bash -l
```

→ **[Which variant to use?](../variants/overview.md)** | **[Kubernetes Usage](kubernetes.md)** | **[Real-world Examples](../guides/examples.md)** | **[Troubleshooting](../guides/troubleshooting.md)**
