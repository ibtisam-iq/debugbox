# Contributing

We welcome contributions to DebugBox!

## Before You Start

1. **Identify the variant** — Which image does your change affect?
2. **Check for duplication** — Does this tool overlap with existing functionality?
3. **Consider image size** — Will this bloat the image unnecessarily?
4. **Test locally** — Use `make build-<variant>` and `make test-<variant>`
5. **Update documentation** — Document user-visible changes in `[docs/manifest.yaml](../manifest.yaml)`

## Guidelines

### Do

- Add tools that fill genuine debugging gaps
- Group tools logically (network, system, editors)
- Pin critical binaries with SHA verification
- Test on both amd64 and arm64 if possible
- Update `[docs/manifest.yaml](../manifest.yaml)` with tool additions

### Don't

- Add overlapping tools (e.g., `wget` when `curl` exists)
- Bloat Lite variant with heavy packages
- Skip documentation updates
- Introduce undocumented helpers or magic behavior

## Process

1. Fork the repository
2. Create a feature branch: `git checkout -b add/my-tool`
3. Make your changes
4. Test locally: `make build-balanced && make test-balanced`
5. Update `[docs/manifest.yaml](../manifest.yaml)`
6. Commit with clear messages
7. Push and open a pull request

## Questions?

Open an issue or discussion on GitHub.

---

For more details, see [CONTRIBUTING.md](https://github.com/ibtisam-iq/debugbox/blob/main/CONTRIBUTING.md) in the repository.
