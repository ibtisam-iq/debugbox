# Docker Usage

DebugBox integrates seamlessly with Docker for local development and container inspection.

## Interactive Session

```bash
docker run -it --rm ghcr.io/ibtisam-iq/debugbox
```

## Share Another Container's Network

Inspect a running container's network namespace:

```bash
docker run -it --rm \
  --net container:my-app-container \
  ghcr.io/ibtisam-iq/debugbox

# Inside — same network as my-app-container
curl localhost:8080
netstat -tulpn
```

## Host Network Access

Debug the Docker host directly:

```bash
docker run -it --rm --net host ghcr.io/ibtisam-iq/debugbox

# Inside — host network context
ip route
iptables -L
```

## Volume Mount for Artifacts

Save captures or logs to host:

```bash
docker run -it --rm -v $(pwd)/captures:/captures ghcr.io/ibtisam-iq/debugbox-power

# Inside
tcpdump -i eth0 -w /captures/traffic.pcap
```

## Docker Compose Sidecar

```yaml
services:
  app:
    image: nginx:alpine
    ports: ["80:80"]

  debugbox:
    image: ghcr.io/ibtisam-iq/debugbox
    network_mode: service:app
    command: sleep infinity
    tty: true
```

Then:
```bash
docker compose exec debugbox bash
curl localhost:80
```

## Variant Selection

- Lite: `ghcr.io/ibtisam-iq/debugbox-lite`
- Balanced (default): `ghcr.io/ibtisam-iq/debugbox`
- Power: `ghcr.io/ibtisam-iq/debugbox-power`

→ More real-world scenarios: **[Examples](../guides/examples.md)**
