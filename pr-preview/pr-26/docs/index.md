---
title: DebugBox - Multi-Variant Kubernetes Debugging. Pull Only What You Need.
description: >
  DebugBox provides three focused debugging container images for Kubernetes and Docker:
  lite (15 MB) for DNS and connectivity, balanced (47 MB) for daily troubleshooting,
  and power (91 MB) for packet capture and deep forensics. Pull only what you need.
hide:
  - navigation
  - toc
---

## Quick Start

```bash
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox
```

→ **[Full quick start guide](getting-started/quick-start.md)**

---

## Why DebugBox?

Modern pods often lack basic debugging tools. DebugBox gives you **three focused variants** so you only pull what you need.

> ~15 MB for basic connectivity. ~47 MB for daily debugging. ~91 MB only when you need advanced forensics.

→ **[See the full motivation](getting-started/motivation.md)**

---

## Explore the Docs

<div class="grid cards" markdown>

- **[:material-run-fast: Getting Started](getting-started/quick-start.md)**
  First steps, registries, motivation

- **[:material-layers: Variants](variants/overview.md)**
  Compare lite, balanced, and power, then choose the right one

- **[:material-kubernetes: Kubernetes Usage](usage/kubernetes.md)**
  `kubectl debug`, ephemeral containers, sidecar patterns

- **[:material-docker: Docker Usage](usage/docker.md)**
  Network namespace sharing, host inspection

- **[:material-tools: Tooling Manifest](reference/manifest.md)**
  Complete list of included tools per variant

- **[:material-book-open-page-variant: Examples](guides/examples.md)**
  Real-world debugging scenarios

- **[:material-school: Interactive Tutorial](https://labs.iximiuz.com/tutorials/kubernetes-debugging-with-debugbox-74e481c8)**
  Hands-on Kubernetes debugging in a live playground

- **[:material-shield-check: Security](security/policy.md)**
  Reporting, scanning, and security practices

- **[:material-console-line: Development](development/local-setup.md)**
  Build, test, and scan locally

</div>

---

**Ready to debug faster?**

Start with [Quick Start](getting-started/quick-start.md) or [choose your variant](variants/overview.md).

Built for Kubernetes debugging by [@ibtisam-iq](https://github.com/ibtisam-iq) · [MIT License](https://github.com/ibtisam-iq/debugbox/blob/main/LICENSE)
