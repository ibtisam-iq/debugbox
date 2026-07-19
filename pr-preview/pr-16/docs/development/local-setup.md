# Local Development Setup

Build, test, and contribute to DebugBox locally.

## Prerequisites

- **Docker** (or Podman with `alias docker=podman`)
- **Make** (GNU make)
- **Git**
- **Python 3.8+** (for MkDocs documentation preview)

## Clone & Setup

```bash
git clone https://github.com/ibtisam-iq/debugbox.git
cd debugbox
```

## Build Commands

### Build All Variants

Builds all three variants for the host architecture:

```bash
make build-all
```

**Output:**
```
debugbox:lite-local
debugbox:balanced-local
debugbox:power-local
```

### Build Single Variant

```bash
make build-lite      # ~15 MB
make build-balanced  # ~47 MB
make build-power     # ~91 MB
```

### Build for Specific Architecture

```bash
PLATFORM=linux/arm64 make build-balanced
PLATFORM=linux/amd64 make build-power
```

### Skip Cache (Fresh Build)

```bash
NO_CACHE=true make build-all
```

## Quality Checks

### Lint Dockerfiles

Runs **hadolint** to check Dockerfile syntax and best practices:

```bash
make lint
```

Uses local `hadolint` if available, otherwise runs containerized version.

### Security Scanning

Scans images with **Trivy** for vulnerabilities (HIGH/CRITICAL only):

```bash
make scan
```

Requires `build-all` first (auto-triggered).

## Test Commands

### Run All Tests

Executes smoke tests on all three variants:

```bash
make test-all
```

Auto-builds and lints first.

### Test Single Variant

```bash
make test-lite
make test-balanced
make test-power
```

**What's tested:** Each variant runs [`tests/smoke.sh`](https://github.com/ibtisam-iq/debugbox/blob/main/tests/smoke.sh) to verify:

- Essential tools are present
- Shells work correctly
- Network tools function
- Helpers are available (balanced+)

### Manual Testing

```bash
docker run -it debugbox:lite-local sh

docker run -it debugbox:balanced-local bash
tcpdump --version

docker run -it debugbox:power-local bash
tshark -v
```

## Documentation Preview

### Install Dependencies

```bash
pip install -r requirements.txt
```

### Start Local Server

```bash
mkdocs serve
```

Opens at **http://localhost:8000** with live reload.

### Build Static Docs

```bash
mkdocs build
# Output in site/
```

## Development Workflow

### Make a Change

1. **Edit Dockerfile:**
   ```bash
   vim dockerfiles/Dockerfile.balanced
   ```

2. **Edit docs:**
   ```bash
   vim docs/manifest.yaml
   ```

3. **Build locally:**
   ```bash
   make build-balanced
   ```

4. **Test the changes:**
   ```bash
   make test-balanced
   ```

5. **Preview docs:**
   ```bash
   mkdocs serve
   ```

### Quality Gates

Before committing, run the full pipeline:

```bash
make lint        # Dockerfile syntax
make build-all   # All variants build
make test-all    # All tests pass
make scan        # No vulnerabilities
```

Or shortcut:

```bash
make check       # Runs lint → build-all → test-all → scan
```

## Make Targets Reference

| Command | Purpose |
|---------|---------|
| `make help` | Show all available commands |
| `make build-all` | Build all variants (host architecture) |
| `make run-<variant>` | Run variant interactively |
| `make build-<variant>` | Build single variant (lite/balanced/power) |
| `make test-all` | Test all variants |
| `make test-<variant>` | Test single variant |
| `make lint` | Lint all Dockerfiles |
| `make scan` | Security scan with Trivy |
| `make check` | Full pipeline (lint → build → test → scan) |
| `make clean` | Remove local images |

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `LOCAL_TAG` | `local` | Local build tag suffix |
| `PLATFORM` | host architecture (e.g. `linux/amd64`) | Target architecture |
| `NO_CACHE` | `false` | Disable Docker build cache |

**Example:**
```bash
PLATFORM=linux/amd64 NO_CACHE=true make build-all
```

## Troubleshooting

### Make not found

```bash
# macOS
brew install make

# Ubuntu/Debian
sudo apt install make
```

### Build fails with permission error

```bash
# Ensure Docker daemon is running
sudo systemctl start docker

# Or use Docker Desktop (Mac/Windows)
```

### Build fails with `exec /bin/sh: exec format error`

This error occurs when building for a foreign architecture without binfmt/QEMU support. The Makefile defaults to the host architecture automatically (`PLATFORM ?= linux/$(HOST_ARCH)`), so this error only appears when `PLATFORM` is explicitly set to a different architecture than the host.

**Option 1: Enable multi-architecture builds (recommended)**

Install binfmt/QEMU emulation to build for any architecture on any host:

```bash
docker run --privileged --rm tonistiigi/binfmt --install all
```

**Option 2: Build for the host architecture only**

Omit the `PLATFORM` override and let the Makefile detect the host:

```bash
make build-lite
```

To verify which platform will be used:

```bash
uname -m
```

### Trivy scan errors

```bash
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin v0.69.1

# Or skip scan
make build-all test-all
```

### MkDocs port already in use

```bash
mkdocs serve --dev-addr=127.0.0.1:8001
```

## Next Steps

→ **[Contributing Guidelines](https://github.com/ibtisam-iq/debugbox/blob/main/CONTRIBUTING.md)** | **[Release Process](https://github.com/ibtisam-iq/debugbox/blob/main/RELEASE.md)** | **[Architecture](../reference/manifest.md)**
