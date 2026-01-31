# Troubleshooting & FAQ

Common issues, solutions, and frequently asked questions when using DebugBox.

## Image Pull Failures

**Symptoms:** `ImagePullBackOff`, `ErrImagePull`

**Causes & Solutions:**

- **Wrong tag/name:** Verify exact image name
  ```bash
  # Correct examples
  ghcr.io/ibtisam-iq/debugbox              # balanced
  ghcr.io/ibtisam-iq/debugbox-lite
  ghcr.io/ibtisam-iq/debugbox-power:v1.0.0
  ```

- **GHCR authentication required** (common in private clusters):
  Configure image pull secret for `ghcr.io` or use Docker Hub mirror:
  ```bash
  --image=docker.io/mibtisam/debugbox
  ```

- **Network restrictions:** Pre-pull on nodes or use internal mirror

## Tool Not Found (e.g., bash, tcpdump, vim)

**Symptoms:** `command not found`

**Diagnosis & Solution:**

Use the correct variant:

| Missing Tool      | Required Variant | Command Example                              |
|-------------------|------------------|----------------------------------------------|
| `bash`, `vim`     | balanced+       | `ghcr.io/ibtisam-iq/debugbox`               |
| `tcpdump`, `strace` | balanced+     | `ghcr.io/ibtisam-iq/debugbox`               |
| `tshark`, `nftables` | power         | `ghcr.io/ibtisam-iq/debugbox-power`         |

Lite only has `ash`, `curl`, `dig`, `jq`, `yq`.

## Permission Denied (tcpdump, raw sockets)

**Symptoms:** `tcpdump: permission denied` or similar

**Cause:** Missing Linux capabilities (`NET_ADMIN`, `NET_RAW`)

**Solutions:**

- For ephemeral containers: Kubernetes drops capabilities by default in newer versions
  Use standalone pod instead:
  ```bash
  kubectl run debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never
  ```

- Or add capabilities explicitly (requires cluster privileges):
  ```bash
  kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox --cap-add=NET_ADMIN,NET_RAW
  ```

## kubectl debug Not Working

**Symptoms:** Command fails or "debug subcommand not available"

**Check:**

```bash
kubectl version --short                  # Needs v1.23+
kubectl api-versions | grep debugging    # Should show debugging.k8s.io/v1
```

**Alternative:** Always use standalone pod:
```bash
kubectl run debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never
```

## Slow Image Pull

**Solution:** Use **lite** variant for fastest startup:
```bash
--image=ghcr.io/ibtisam-iq/debugbox-lite   # ~14 MB
```

Pre-pull on nodes if recurring:
```bash
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | xargs -I{} kubectl ssh {} -- docker pull ghcr.io/ibtisam-iq/debugbox
```

## DNS Issues Inside Container

**Symptoms:** `dig` fails, no resolution

**Check:**

```bash
cat /etc/resolv.conf
```

- In `kubectl debug`: Should match target pod (usually correct)
- In standalone pod: Uses pod's DNS (cluster DNS)
- If broken: May be cluster-wide CoreDNS issue

Test known-good domain:
```bash
dig google.com
```

## Architecture Mismatch (arm64 nodes)

**Symptoms:** `exec format error`, image pull fails

**Solution:** DebugBox images are multi-arch — no special tag needed.

Verify node arch:
```bash
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.nodeInfo.architecture}{"\n"}{end}'
```

All variants support `amd64` and `arm64`.

## Container Exits Immediately

**Cause:** Missing `-it` or `--rm` with no TTY

**Fix:** Always include interactive flags:
```bash
kubectl run debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never
```

## Frequently Asked Questions

### Does DebugBox include kubectl?

**No — intentionally.**

DebugBox is a **debugging toolbox**, not a Kubernetes client. Including `kubectl` would:

- Bloat image size
- Duplicate your workstation capability
- Encourage insecure control-plane access

**Pattern:** Run `kubectl` locally and pipe output:
```bash
kubectl logs my-pod | kubectl run debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never -- cat
```

### Can I run non-root?

Yes, but many tools (`tcpdump`, `strace`) require root.

Override:
```bash
docker run -it --rm --user 1000:1000 ghcr.io/ibtisam-iq/debugbox-lite
```

### Why no helm, k9s, etc.?

DebugBox is **focused on low-level debugging** — network, system, process.  
Deployment tools are out of scope to keep images small and secure.

→ See **[Variants Overview](../variants/overview.md)** for tool breakdown

## Still Stuck?

- Review **[Examples](../guides/examples.md)**
- Check cluster logs: `kubectl logs -n kube-system coredns-...`
- Open a GitHub issue with:
    - DebugBox variant/tag used
    - Kubernetes/Docker version
    - Exact command and error output

You're not alone — the community is here to help.
