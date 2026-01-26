# Multi-Architecture Support

All DebugBox images are multi-platform manifests.

## Supported Architectures

- `linux/amd64` (x86_64) — Intel/AMD servers, most VMs
- `linux/arm64` (aarch64) — Apple Silicon (M1–M4), AWS Graviton, Raspberry Pi 64-bit

## Automatic Selection

Docker, containerd, and Kubernetes automatically pull the correct architecture.

```bash
# Works seamlessly on both amd64 and arm64
docker pull ghcr.io/ibtisam-iq/debugbox:latest
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox
```

No `--platform` flag needed.

## Explicit Platform (Rare)

```bash
docker pull --platform linux/arm64 ghcr.io/ibtisam-iq/debugbox
```

## Verify Inside Container

```bash
uname -m
# x86_64 → amd64
# aarch64 → arm64
```

→ **[Variants Overview](../variants/overview.md)** | **[Tooling Manifest](manifest.md)** →
