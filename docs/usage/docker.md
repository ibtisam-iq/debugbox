# Docker Usage

DebugBox works seamlessly with Docker for local and remote debugging.

## Interactive Shell

Start a DebugBox container interactively:

```bash
docker run -it --rm ghcr.io/ibtisam-iq/debugbox
```

The `--rm` flag automatically removes the container when you exit.

---

## Debug Another Container's Network

Debug a running container's network namespace:

```bash
docker run -it --rm \
  --net container:my-app-container \
  ghcr.io/ibtisam-iq/debugbox
```

Inside this container, you can inspect the target container's network stack, ports, and connections without modifying it.

---

## Host Network Debugging

Debug the Docker host's network:

```bash
docker run -it --rm \
  --net host \
  ghcr.io/ibtisam-iq/debugbox
```

This gives you access to the host's network interfaces, routing tables, and firewall rules.

---

## Bind Mount for Analysis

Capture traffic and save it for analysis:

```bash
docker run -it --rm \
  -v /tmp:/tmp \
  ghcr.io/ibtisam-iq/debugbox

# Inside
tcpdump -i eth0 -w /tmp/capture.pcap
# Ctrl+C to stop
```

The pcap file is saved to your host's `/tmp` for later analysis.

---

## Docker Compose Integration

Use DebugBox in a Docker Compose environment:

```yaml
version: '3.8'
services:
  app:
    image: nginx:alpine
    ports:
      - "80:80"
  
  debugbox:
    image: ghcr.io/ibtisam-iq/debugbox
    command: sleep infinity
    stdin_open: true
    tty: true
    network_mode: service:app  # Share app's network
```

Then debug the app:

```bash
docker-compose exec debugbox bash

# Inside (shares app's network)
curl localhost:80
netstat -tulpn
```

---

## Privileged Mode (Advanced)

For low-level debugging requiring special capabilities:

```bash
docker run -it --rm \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_PTRACE \
  ghcr.io/ibtisam-iq/debugbox-power

# Inside
tcpdump -i eth0
strace -p <pid>
```

---

## Variant Selection

```bash
# Lightweight (lite)
docker run -it --rm ghcr.io/ibtisam-iq/debugbox-lite

# Balanced (default, recommended)
docker run -it --rm ghcr.io/ibtisam-iq/debugbox

# Full forensics (power)
docker run -it --rm ghcr.io/ibtisam-iq/debugbox-power
```

---

## Common Patterns

### Test Connectivity to Service

```bash
docker run -it --rm ghcr.io/ibtisam-iq/debugbox

# Inside
curl http://my-service:8080
dig my-service
```

### Monitor Network in Real-Time

```bash
docker run -it --rm ghcr.io/ibtisam-iq/debugbox

# Inside
iftop -i eth0
```

### Analyze Host Network

```bash
docker run -it --rm --net host ghcr.io/ibtisam-iq/debugbox

# Inside (host context)
ip route
ip neigh
netstat -tulpn
```
