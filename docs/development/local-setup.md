# Local Development

Set up DebugBox for local development.

## Prerequisites

- Docker or Podman
- Make
- Python 3.11+ (for documentation)
- Git

---

## Clone Repository

```bash
git clone https://github.com/ibtisam-iq/debugbox.git
cd debugbox
```

---

## Build Images

### Single Variant

```bash
# Build specific variant
make build-lite
make build-balanced
make build-power
```

### All Variants

```bash
make build-all
```

### Multi-Architecture

```bash
# Default builds both amd64 and arm64
make build-balanced

# Build for specific platform
PLATFORM=linux/arm64 make build-lite
```

---

## Test Images

### Smoke Tests

```bash
# Test specific variant
make test-lite
make test-balanced
make test-power

# Test all variants
make test-all
```

---

## Security Scanning

### Scan with Trivy

```bash
make scan
```

Scanning checks for HIGH and CRITICAL vulnerabilities. Build fails if found.

---

## Lint Dockerfiles

```bash
make lint
```

---

## Documentation

### Build Documentation

```bash
pip install -r requirements.txt
mkdocs build
```

### Preview Documentation

```bash
mkdocs serve
```

Then open http://localhost:8000

---

## Makefile Targets

Common targets in the Makefile:

| Target | Description |
|--------|-------------|
| `build-lite` | Build lite variant |
| `build-balanced` | Build balanced variant |
| `build-power` | Build power variant |
| `build-all` | Build all variants |
| `test-lite` | Test lite variant |
| `test-balanced` | Test balanced variant |
| `test-power` | Test power variant |
| `test-all` | Test all variants |
| `scan` | Security scan with Trivy |
| `lint` | Lint Dockerfiles |

---

## Code Structure

```
.
├── dockerfiles/          # All Dockerfiles
├── docs/                 # Documentation
├── scripts/              # Installation scripts
├── tests/                # Test scripts
├── Makefile              # Build automation
└── mkdocs.yml            # Documentation config
```

---

## Next Steps

- Read the [Project Structure](structure.md)
- Review [Contributing Guidelines](contributing.md)
- Check the [Release Process](release.md)
