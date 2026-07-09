# Multi-Architecture Support

All DebugBox images are **multi-platform manifests** supporting both common CPU architectures.

## Supported Architectures

- **`linux/amd64`** (x86_64) -- Intel/AMD servers, most cloud VMs, GitHub Actions
- **`linux/arm64`** (aarch64) -- Apple Silicon (M1-M5), AWS Graviton, Raspberry Pi 64-bit

## Automatic Selection

Docker, containerd, and Kubernetes automatically pull the correct architecture for your platform. No manual configuration needed.

```bash
# Works seamlessly on both amd64 and arm64
docker pull ghcr.io/ibtisam-iq/debugbox:1.0.0
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:1.0.0
```

The registry returns the correct image for your CPU architecture automatically.

## Explicit Platform (Rare)

To explicitly request a specific architecture (for testing or compatibility):

```bash
# Force arm64 on an amd64 machine
docker pull --platform linux/arm64 ghcr.io/ibtisam-iq/debugbox:1.0.0

# Run with specific platform
docker run --platform linux/arm64 ghcr.io/ibtisam-iq/debugbox:1.0.0
```

## Verify Inside Container

```bash
uname -m
# x86_64 → amd64
# aarch64 → arm64
```

→ **[Variants Overview](../variants/overview.md)** | **[Tooling Manifest](manifest.md)**
