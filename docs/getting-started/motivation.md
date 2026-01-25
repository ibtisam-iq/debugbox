# Why DebugBox?

DebugBox exists because debugging Kubernetes workloads shouldn't be complicated.

## The Problem

During CKA/CKAD prep and production troubleshooting, I repeatedly hit a frustrating pattern:

```bash
$ kubectl exec -it my-pod -- curl
exec: "curl": executable file not found
```

Modern production pods (distroless, Alpine) ship without debugging tools. Existing solutions like netshoot work but require downloading a 208MB image even for basic network checks.

## The Solution

**Three focused variants instead of one monolithic image.**

- **lite (15MB):** Fast pull for quick network/DNS checks
- **balanced (48MB):** Daily-driver for most troubleshooting
- **power (110MB):** Deep forensics and packet analysis

### Why Variants Matter

```
netshoot:         208 MB  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 100%
DebugBox power:   110 MB  ━━━━━━━━━━━━━━━━━━━━━━ 53%
DebugBox balanced: 48 MB  ━━━━━━━━━ 23%
DebugBox lite:     15 MB  ━━ 7%
```

**4.3x smaller** for 90% of use cases means faster pod startup in production incidents.

## Key Principles

### 1. Variants Over Bloat

Each variant installs only what it promises. Balanced doesn't carry forensics tools. Lite stays minimal.

### 2. Deterministic Builds

Critical binaries are pinned and SHA-verified (Power variant). No surprise version drift.

### 3. Explicit Contracts

[`docs/manifest.yaml`](../manifest.yaml) documents exactly what tools are included. No hidden packages.

### 4. Debug-First Philosophy

Runs as root by design. This is a debugging tool, not a production workload.

### 5. Engineering Clarity

- Makefile-driven local development
- CI/CD automation for builds, tests, and releases
- Trivy security scans on every release
- Zero magic — every tool is documented and intentional

## Real-World Scenarios

### Quick Network Check (lite)

```bash
$ kubectl run debugbox --rm -it --image=ghcr.io/ibtisam-iq/debugbox-lite
# Pull: 15 MB (fast!)
# Time to troubleshoot: <5 seconds
```

### Daily Debugging (balanced)

```bash
$ kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox
# Pull: 48 MB (reasonable)
# Tools: curl, dig, tcpdump, strace, kubectx...
# Time to troubleshoot: <30 seconds
```

### Deep Forensics (power)

```bash
$ kubectl run debugbox-power --rm -it --image=ghcr.io/ibtisam-iq/debugbox-power
# Pull: 110 MB (for serious analysis)
# Tools: tshark, ltrace, iptables, nftables, bird...
# Time to troubleshoot: as long as needed
```

## Comparison to Alternatives

| Feature | DebugBox | netshoot | busybox |
|---------|----------|----------|---------|
| Multiple variants | ✓ | ✗ | ✗ |
| Smallest variant | 15 MB | 208 MB | 1.5 MB |
| Kubernetes-focused | ✓ | ✓ | ✗ |
| Multi-arch | ✓ | ✓ | ✓ |
| Pinned binaries | ✓ (Power) | ✗ | ✗ |
| Version guarantees | ✓ | ✗ | ✗ |
| Security scans | ✓ | ✗ | ✗ |

**Choose DebugBox if:** You want a lean, focused debugging tool with multiple size options.

**Choose netshoot if:** You need every tool in one image and don't care about size.

**Choose busybox if:** You literally only need `sh` and `ping`.

## What DebugBox is NOT

- ❌ **Not a sidecar container:** Use `kubectl debug` ephemeral containers
- ❌ **Not production-workload ready:** Runs as root; for debugging only
- ❌ **Not a monolithic toolbox:** Each variant is focused; use the right one
- ❌ **Not a security scanner:** This is for troubleshooting, not vulnerability assessment
