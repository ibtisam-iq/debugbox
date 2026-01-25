# Multi-Architecture Support

All DebugBox images are published as multi-architecture manifests.

## Supported Platforms

- `linux/amd64` — x86_64 (Intel, AMD)
- `linux/arm64` — ARM 64-bit (aarch64)

---

## Compatible Hardware

### x86_64 (amd64)

- Standard Linux servers
- Virtual machines (AWS EC2, Azure VMs, GCP)
- Desktop/laptop computers
- Older Apple Macs (Intel)

### ARM64 (aarch64)

- **Apple Silicon:** M1, M2, M3, M4 (native support)
- **AWS Graviton:** EC2 instances (t4g, m7g, c7g families)
- **Azure Ampere:** A1 Compute instances
- **Raspberry Pi:** 64-bit models (Pi 3B+, Pi 4, Pi 5)
- **Other ARM64 hardware:** Any 64-bit ARM Linux system

---

## Automatic Selection

Docker and containerd automatically detect your architecture and pull the correct image variant. **No platform-specific tags needed.**

```bash
# Works on both amd64 and arm64 automatically
docker pull ghcr.io/ibtisam-iq/debugbox:latest
kubectl ... --image=ghcr.io/ibtisam-iq/debugbox:latest
```

---

## Explicit Architecture Selection (Advanced)

If you need to explicitly specify architecture:

```bash
# Force x86_64 (may fail if not running on x86_64)
docker pull --platform linux/amd64 ghcr.io/ibtisam-iq/debugbox

# Force ARM64
docker pull --platform linux/arm64 ghcr.io/ibtisam-iq/debugbox
```

---

## Size Parity

Both architectures have similar sizes:

| Variant | amd64 | arm64 |
|---------|-------|-------|
| lite | 15 MB | 15 MB |
| balanced | 48 MB | 48 MB |
| power | 110 MB | 103 MB |

---

## Verification

Verify which architecture is running:

```bash
# Inside container
uname -m

# amd64 → x86_64
# arm64 → aarch64
```

---

## CI/CD Builds

All images are built for both architectures in CI/CD:

- ✅ GitHub Actions builds amd64 + arm64
- ✅ Trivy security scanning on both
- ✅ Both pushed to GHCR and Docker Hub
- ✅ Single multi-arch manifest per tag

See [`release.yml`](https://github.com/ibtisam-iq/debugbox/blob/main/.github/workflows/release.yml) for details.
