# Installation

Get started with DebugBox in three commands.

## Prerequisites

- Kubernetes 1.16+ (for `kubectl debug` support)
- Docker or Podman (for local use)
- kubectl (for Kubernetes examples)

---

## Kubernetes Quick Start

### Option 1: Debug Existing Pod (Recommended)

Attach an ephemeral container to an existing pod:

```bash
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox
```

This shares the target pod's network namespace. No modification to the pod.

### Option 2: Temporary Debugging Pod

Spin up a dedicated debugging pod:

```bash
kubectl run debugbox --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never
```

The `--rm` flag automatically deletes the pod when you exit.

### Option 3: Docker

```bash
docker run -it --rm ghcr.io/ibtisam-iq/debugbox
```

---

## Choosing a Variant

### Lite (15 MB) – Fast Network Checks

```bash
kubectl run debugbox-lite --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-lite \
  --restart=Never
```

**Use when:**
- Fast pulls matter (slow networks, production incidents)
- You only need: curl, dig, ping, netcat, jq, yq
- Running in resource-constrained clusters

### Balanced (48 MB) – Recommended Default

```bash
kubectl debug my-pod -it \
  --image=ghcr.io/ibtisam-iq/debugbox
```

**Use when:**
- General Kubernetes troubleshooting
- Daily debugging workflows
- You need: bash, tcpdump, strace, kubectx, vim
- **This is the default choice when unsure**

### Power (110 MB) – Deep Forensics

```bash
kubectl run debugbox-power --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-power \
  --restart=Never
```

**Use when:**
- Deep network packet analysis (tshark)
- Advanced routing/firewall debugging (iptables, nftables)
- System-level tracing (ltrace)
- Running custom Python scripts

---

## Image Registries

### GitHub Container Registry (GHCR) – Primary

Recommended for faster pulls and better GitHub integration:

```bash
ghcr.io/ibtisam-iq/debugbox-lite:latest
ghcr.io/ibtisam-iq/debugbox:latest
ghcr.io/ibtisam-iq/debugbox-power:latest
```

### Docker Hub – Mirror

Alternative registry with identical content:

```bash
docker.io/mibtisam/debugbox-lite:latest
docker.io/mibtisam/debugbox:latest
docker.io/mibtisam/debugbox-power:latest
```

---

## Version Tags

### Latest (Recommended for Interactive Use)

```bash
kubectl ... --image=ghcr.io/ibtisam-iq/debugbox:latest
```

### Pinned Version (Recommended for CI/CD)

```bash
kubectl ... --image=ghcr.io/ibtisam-iq/debugbox:{{ git.tag or git.describe }}
```

Use pinned versions for reproducibility in CI/CD pipelines.

---

## Default Variant

The unqualified image name always points to **balanced**:

```
ghcr.io/ibtisam-iq/debugbox
  ↓
ghcr.io/ibtisam-iq/debugbox-balanced
```

---

## Verify Installation

Test that the image pulls correctly:

```bash
kubectl run debugbox-test --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never \
  -- bash -c "curl --version && dig --version && echo 'OK'"
```

Expected output:
```
curl 7.x.x
DiG 9.x.x
OK
```

---

## Network Requirements

To pull DebugBox images, your cluster must be able to reach:

- **GHCR:** `ghcr.io` (primary)
- **Docker Hub:** `docker.io` (fallback)

If your cluster has restricted internet access, consider:
1. Pre-pulling images on nodes
2. Using a private registry mirror
3. Using the Docker Hub variant if GHCR is blocked

---

## Next Steps

- **[Quick Start](quick-start.md)** – 60-second examples
- **[Variants](../variants/overview.md)** – Detailed variant comparison
- **[Usage](../usage/kubernetes.md)** – Detailed usage guides
- **[Troubleshooting](../guides/troubleshooting.md)** – Common issues and solutions

---

## What's Included

Each variant includes:
- **Network debugging:** curl, dig, netcat, ip, ping, traceroute
- **Data tools:** jq, yq (JSON/YAML parsing)
- **Kubernetes:** kubectl (CLI), kubectx (context switching)

**Balanced adds:**
- Full bash shell with completion
- Text editors (vim, less)
- System tools (strace, htop, lsof)
- Advanced networking (tcpdump, nmap, mtr)

**Power adds:**
- Packet analysis (tshark from Wireshark)
- Deep tracing (ltrace)
- Routing/firewall (iptables, nftables, bird)
- Python scripting (pip3)

→ [Full tooling reference](../manifest.yaml)
