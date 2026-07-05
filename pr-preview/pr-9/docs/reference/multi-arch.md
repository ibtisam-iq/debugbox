# Multi-Architecture Support

All DebugBox images are **multi-platform manifests** supporting both common CPU architectures.

## Supported Architectures

- **`linux/amd64`** (x86_64) — Intel/AMD servers, most cloud VMs, GitHub Actions
- **`linux/arm64`** (aarch64) — Apple Silicon (M1–M5), AWS Graviton, Raspberry Pi 64-bit

## Automatic Selection

Docker, containerd, and Kubernetes automatically pull the correct architecture for your platform — no manual configuration needed.

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

Check which architecture you're running:

```bash
# Command 1: Check CPU arch
uname -m
# Output: x86_64 → amd64
# Output: aarch64 → arm64

# Command 2: Check full uname info
uname -a

# Command 3: View CPU info
cat /proc/cpuinfo | grep processor
```

## Real-World Examples

### Apple Silicon (M1–M5)
```bash
docker run -it ghcr.io/ibtisam-iq/debugbox:1.0.0
# Automatically pulls linux/arm64
```

### AWS Graviton EC2 Instance
```bash
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:1.0.0
# Automatically pulls linux/arm64
```

### Traditional Intel/AMD Server
```bash
docker pull ghcr.io/ibtisam-iq/debugbox:1.0.0
# Automatically pulls linux/amd64
```

### Raspberry Pi 64-bit
```bash
docker run -it ghcr.io/ibtisam-iq/debugbox:lite:1.0.0
# Automatically pulls linux/arm64 (minimal 14 MB pull)
```

## Multi-Architecture Build Process

Every DebugBox release builds all three variants for both architectures:

| Variant | amd64 | arm64 |
|---------|-------|-------|
| lite | ✓ | ✓ |
| balanced | ✓ | ✓ |
| power | ✓ | ✓ |

This ensures feature parity and performance across all platforms.

→ **[Variants Overview](../variants/overview.md)** | **[Tooling Manifest](manifest.md)** →
