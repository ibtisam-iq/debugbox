# Installation

DebugBox is a container image — **no installation required**.

Simply pull from either registry:

```bash
# GHCR (recommended, faster)
ghcr.io/ibtisam-iq/debugbox              # balanced (default)
ghcr.io/ibtisam-iq/debugbox:lite
ghcr.io/ibtisam-iq/debugbox:power

# Docker Hub (mirror)
mibtisam/debugbox
mibtisam/debugbox:lite
mibtisam/debugbox:power
```

All images support **amd64** (Intel/AMD) and **arm64** (Apple Silicon, Graviton, Raspberry Pi).

**Note:** Unqualified names (`debugbox`) always refer to the **balanced** variant.

## Tag Formats

For production, always pin versions:

```bash
ghcr.io/ibtisam-iq/debugbox:1.0.0           # Balanced v1.0.0
ghcr.io/ibtisam-iq/debugbox:lite-1.0.0      # Lite v1.0.0
ghcr.io/ibtisam-iq/debugbox:power-1.0.0     # Power v1.0.0
```

→ **[Complete tag reference](../reference/tags.md)**

## Usage

### Kubernetes
```bash
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:1.0.0
```

### Docker
```bash
docker run -it ghcr.io/ibtisam-iq/debugbox:1.0.0
```

→ **[Kubernetes usage](../usage/kubernetes.md)** | **[Docker usage](../usage/docker.md)**
