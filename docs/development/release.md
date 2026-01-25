# Release Process

How DebugBox releases are managed and published.

## Versioning

DebugBox follows semantic versioning:

- **MAJOR**: Incompatible changes (tool removal, breaking API)
- **MINOR**: New functionality (new tools, variants)
- **PATCH**: Bug fixes and updates

**Format:** `vMAJOR.MINOR.PATCH`

**Example:** `{{ git.tag or git.describe }}`

---

## Release Checklist

Before releasing:

- [ ] All tests pass: `make test-all`
- [ ] Security scan passes: `make scan`
- [ ] Documentation is up to date
- [ ] CHANGELOG.md is updated
- [ ] Version bump is correct
- [ ] Commit messages are clear

---

## Release Steps

### 1. Update Documentation

```bash
# Update docs/manifest.yaml with any new tools
vim docs/manifest.yaml

# Update CHANGELOG.md with release notes
vim CHANGELOG.md
```

### 2. Create Release Tag

```bash
git tag vX.Y.Z
git push origin vX.Y.Z
```

> Once the tag is pushed:
>
> * `git.tag` becomes `vX.Y.Z`
> * Documentation freezes at this version
> * Images are published with this tag

### 3. Automated Deployment

GitHub Actions automatically:

1. Detects the tag
2. Builds multi-arch images (amd64 + arm64)
3. Runs Trivy security scan
4. Pushes to GHCR and Docker Hub
5. Deploys documentation

---

## Image Publishing

After release, images are available at:

* **GHCR:**

  ```bash
  ghcr.io/ibtisam-iq/debugbox:{{ git.tag or git.describe }}
  ```

* **Docker Hub:**

  ```bash
  docker.io/mibtisam/debugbox:{{ git.tag or git.describe }}
  ```

* **Latest tag:**
  Both registries are updated with `latest`

---

## Automated Workflow

The release workflow is defined in [`.github/workflows/deploy.yml`](https://github.com/ibtisam-iq/debugbox/blob/main/.github/workflows/deploy.yml):

1. **Build phase:** Builds multi-arch images
2. **Scan phase:** Trivy security scan
3. **Publish phase:** Push to registries
4. **Deploy phase:** Update documentation

---

## Rollback

If a release has critical issues:

1. Revert the tag:

```bash
git tag -d vX.Y.Z
git push origin :refs/tags/vX.Y.Z
```

2. Fix the issue
3. Release again with patch version.

Example:

```bash
git tag v1.0.1
git push origin v1.0.1
```

---

For detailed instructions, see [RELEASE.md](https://github.com/ibtisam-iq/debugbox/blob/main/RELEASE.md) in the repository.
