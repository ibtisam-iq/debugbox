# Local Development Setup

How to build and test DebugBox locally.

## Prerequisites

- Docker (or Podman)
- Make
- Git

## Clone the Repository

```bash
git clone https://github.com/ibtisam-iq/debugbox.git
cd debugbox
```

## Common Commands

| Command              | Description                              |
|----------------------|------------------------------------------|
| `make build-all`     | Build all variants (amd64 + arm64)       |
| `make build-lite`    | Build only lite variant                  |
| `make test-all`      | Run smoke tests on all variants          |
| `make scan`          | Security scan with Trivy                 |
| `make lint`          | Lint Dockerfiles with hadolint           |

## Multi-Architecture Builds

Default builds both platforms:
```bash
make build-balanced        # amd64 + arm64
```

Force single platform:
```bash
PLATFORM=linux/arm64 make build-power
```

## Preview Documentation

```bash
pip install -r requirements.txt
mkdocs serve
```

Open http://localhost:8000

## Contributing

Want to add a tool or fix a bug?

→ See the full guidelines: [CONTRIBUTING.md on GitHub](https://github.com/ibtisam-iq/debugbox/blob/main/CONTRIBUTING.md)

→ Release process: [RELEASE.md on GitHub](https://github.com/ibtisam-iq/debugbox/blob/main/RELEASE.md)
