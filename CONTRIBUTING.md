# Contributing to DebugBox

Thank you for your interest in contributing!

DebugBox is an open-source Kubernetes debugging toolkit, and contributions of all kinds are welcome — fixes, improvements, docs, CI enhancements, and new tooling proposals.

---

## How to Contribute

### 1. Fork the Repository
Click **Fork** → clone your fork locally.

### 2. Create a Branch
Use a descriptive branch name:

```bash
git checkout -b feat/add-new-tool
git checkout -b fix/typo
```

### 3. Make Your Changes
Follow project standards:

- Keep Dockerfiles clean, deterministic, and minimal.
- For tooling additions, update `dockerfiles/manifest.yaml`.
- Run `make build-balanced` and `make test-balanced` locally.

### 4. Open a Pull Request (PR)
- PR must target **main**
- PR must pass:  
  ✔ Build  
  ✔ Smoke tests  
  ✔ Trivy security scan  
  ✔ Hadolint  
  ✔ Reviewer approval (minimum 1)

### 5. Discuss & Iterate
Maintain a constructive tone, follow the Code of Conduct, and be ready to revise based on reviewer feedback.

---

## Adding New Tools
If you propose adding a new tool:

1. Justify its use-case (Kubernetes networking, cluster debugging, etc.)
2. Add it to `dockerfiles/manifest.yaml`
3. Justify why it belongs to `lite`, `balanced`, or `power`
4. Keep image bloat minimal

---

## Style Guidelines
- Keep Dockerfiles deterministic  
- Prefer single-layer `apk add` blocks with immediate cleanup  
- No massive RUN chains  
- Use `/etc/profile.d/*.sh` for UX additions  
- Avoid adding tooling unrelated to cloud-native/Kubernetes debugging  

---

## Questions?
Open a Discussion or contact the maintainer:

`contact@ibtisam-iq.com`

Thank you for contributing!
