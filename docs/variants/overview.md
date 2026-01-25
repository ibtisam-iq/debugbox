# Variants Overview

DebugBox provides three purpose-built variants instead of one monolithic image.

## At a Glance

| Variant | Size | Use Case | Shell |
|---------|------|----------|-------|
| **lite** | 15 MB | Quick network checks | ash (BusyBox) |
| **balanced** | 48 MB | General troubleshooting | bash |
| **power** | 110 MB | Deep forensics | bash |

## Choosing a Variant

### When to Use lite

- Fast pod startup is critical
- Quick DNS or network checks
- Resource-constrained environments
- Init container debugging

**Start with:** 
```bash
kubectl run debugbox-lite --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-lite
```

### When to Use balanced (Recommended)

- General Kubernetes troubleshooting
- Debugging live pods
- Daily debugging workflows
- Default choice when unsure

**Start with:**
```bash
kubectl debug my-pod -it \
  --image=ghcr.io/ibtisam-iq/debugbox
```

### When to Use power

- Packet captures and analysis
- Deep network forensics
- Routing and firewall debugging
- SRE investigations

**Start with:**
```bash
kubectl run debugbox-power --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-power
```

## Detailed Comparison

### Network Tools

| Tool | lite | balanced | power |
|------|------|----------|-------|
| curl | ✓ | ✓ | ✓ |
| dig | ✓ | ✓ | ✓ |
| netcat | ✓ | ✓ | ✓ |
| ping | ✓ | ✓ | ✓ |
| tcpdump | ✗ | ✓ | ✓ |
| nmap | ✗ | ✓ | ✓ |
| mtr | ✗ | ✓ | ✓ |
| tshark | ✗ | ✗ | ✓ |

### System Tools

| Tool | lite | balanced | power |
|------|------|----------|-------|
| bash | ✗ | ✓ | ✓ |
| vim | ✗ | ✓ | ✓ |
| strace | ✗ | ✓ | ✓ |
| htop | ✗ | ✓ | ✓ |
| lsof | ✗ | ✓ | ✓ |
| ltrace | ✗ | ✗ | ✓ |

### Kubernetes Tools

| Tool | lite | balanced | power |
|------|------|----------|-------|
| kubectl | ✓ | ✓ | ✓ |
| kubectx | ✗ | ✓ | ✓ |
| kubens | ✗ | ✓ | ✓ |
| yq | ✓ | ✓ | ✓ |
| jq | ✓ | ✓ | ✓ |

## Authoritative Tooling List

For the complete, authoritative list of tools in each variant, see [`docs/manifest.yaml`](../manifest.yaml) in the GitHub repository.

## Summary

- **lite:** Lean and fast. Pull time is measured in seconds.
- **balanced:** Sweet spot. Has everything for most troubleshooting.
- **power:** Complete forensics toolkit for deep investigations.

**Start with balanced. Downgrade to lite if startup time is critical. Upgrade to power for detailed analysis.**
