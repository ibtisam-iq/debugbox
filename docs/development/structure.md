# Project Structure

Overview of the DebugBox repository structure.

## Root Directory

```
.
├── dockerfiles/              # Dockerfile definitions
├── docs/                     # Documentation source
├── scripts/                  # Helper scripts
├── tests/                    # Test suites
├── .github/workflows/        # GitHub Actions CI/CD
├── Makefile                  # Build automation
├── mkdocs.yml                # Documentation config
├── requirements.txt          # Python dependencies
├── requirements-dev.txt      # Development dependencies
├── README.md                 # GitHub README
├── CHANGELOG.md              # Version history
├── CONTRIBUTING.md           # Contribution guidelines
├── RELEASE.md                # Release process
├── SECURITY.md               # Security policy
└── LICENSE                   # MIT License
```

---

## dockerfiles/

Image build definitions for all variants.

```
dockerfiles/
├── Dockerfile.base           # Shared Alpine foundation
├── Dockerfile.lite           # Lite variant (15MB)
├── Dockerfile.balanced       # Balanced variant (48MB)
├── Dockerfile.power          # Power variant (110MB)
└── common/
    ├── balanced.packages     # Package installation script
    └── balanced.verify       # Verification/smoke tests
```

---

## docs/

Documentation source for [debugbox.ibtisam-iq.com](https://debugbox.ibtisam-iq.com)

```
docs/
├── index.md                  # Home page
├── getting-started/
│   ├── quick-start.md
│   ├── installation.md
│   └── motivation.md
├── variants/
│   ├── overview.md
│   ├── lite.md
│   ├── balanced.md
│   └── power.md
├── usage/
│   ├── kubernetes.md
│   ├── docker.md
│   └── workflows.md
├── reference/
│   ├── manifest.md
│   ├── tags.md
│   ├── multi-arch.md
│   └── sizes.md
├── development/
│   ├── local-setup.md
│   ├── structure.md
│   ├── contributing.md
│   └── release.md
├── security/
│   ├── policy.md
│   └── scanning.md
└── guides/
    ├── troubleshooting.md
    └── examples.md
```

---

## scripts/

Helper scripts for development and deployment.

```
scripts/
├── install-yq-binary         # Pinned yq installer (SHA-verified)
└── README.md
```

---

## tests/

Automated test suites.

```
tests/
├── smoke.sh                  # Local smoke tests
└── ci-smoke.sh               # CI-only smoke tests (no network)
```

---

## .github/workflows/

GitHub Actions CI/CD pipelines.

```
.github/workflows/
├── ci.yml                    # Build + test on every push
└── deploy.yml                # Publish on release tags
└── docs.yml                  # Publish the site
```

---

## Key Files

### Makefile

Build automation for local development:
- `make build-lite` — Build lite variant
- `make build-all` — Build all variants
- `make test-all` — Run all tests
- `make scan` — Security scanning

### mkdocs.yml

Documentation configuration. Defines:
- Site metadata
- Navigation structure
- Theme and plugins
- Build settings

### requirements.txt

Python dependencies for building documentation:
- mike
- mkdocs
- mkdocs-material
- pymdown-extensions

### .github/workflows/deploy.yml

GitHub Actions workflow for CI/CD:
- Builds images on every push to main
- Runs security scans
- Publishes releases on Git tags
- Deploys documentation

---

## Documentation Flow

```
docs/
  ├─ mkdocs.yml         (Config)
  ├─ *.md               (Markdown sources)
  └─ (build process)
      └─ site/          (Generated HTML)
          └─ Deploy to GitHub Pages
              └─ debugbox.ibtisam-iq.com
```

---

## Adding New Documentation

1. Create `.md` file in appropriate `docs/` subdirectory
2. Add entry to `nav:` section in `mkdocs.yml`
3. Build locally: `mkdocs serve`
4. Commit and push to GitHub
5. CI/CD automatically deploys

Example:

```yaml
# mkdocs.yml
nav:
  - Home: "index.md"
  - Usage:
    - Kubernetes: "usage/kubernetes.md"
    - Docker: "usage/docker.md"
    - New Topic: "usage/new-topic.md"  # Add here
```

---

## Build and Deployment

```
Local development
  ↓ (git push)
GitHub (main branch)
  ↓
CI: build + test + scan
  ↓ (git tag v1.0.0)
Release
  ↓
Deploy: build + push + documentation
  ↓
GHCR + Docker Hub + GitHub Pages
```
