# Troubleshooting Guide

Common issues and solutions when using DebugBox.

## Pod Not Pulling Image

**Problem:** Pod stuck in ImagePullBackOff

**Solution:**

```bash
# Check image availability
docker pull ghcr.io/ibtisam-iq/debugbox:latest

# Verify image name and tag
kubectl get pod -o jsonpath='{.items[0].spec.containers[0].image}'

# If network-restricted, use Docker Hub mirror
kubectl ... --image=docker.io/mibtisam/debugbox:latest
```

---

## No Such File or Directory

**Problem:** `bash: command not found`

**Solution:**

You're using the lite variant (BusyBox shell). Upgrade to balanced:

```bash
# Instead of lite
kubectl ... --image=ghcr.io/ibtisam-iq/debugbox-lite

# Use balanced
kubectl ... --image=ghcr.io/ibtisam-iq/debugbox
```

---

## Ephemeral Container Not Attaching

**Problem:** `kubectl debug` command not working

**Check prerequisites:**

```bash
# Verify Kubernetes version (1.16+)
kubectl version --short

# Check if api server supports debugging
kubectl api-resources | grep debugged
```

**Alternative:**

Use temporary pod instead:

```bash
kubectl run debugbox --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never
```

---

## tcpdump Not Working

**Problem:** `tcpdump: permission denied`

**Solution:**

You need the lite or balanced variant. Use power:

```bash
kubectl run debugbox --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-power
```

Also check if container has NET_ADMIN capability:

```bash
# Inside container
cat /proc/self/status | grep Cap
```

---

## DNS Not Resolving

**Problem:** `dig` returns `SERVFAIL`

**Check setup:**

```bash
# Are you in pod's network namespace?
cat /etc/resolv.conf

# Test with different domain
dig kubernetes.default.svc.cluster.local
dig google.com

# Check if coredns is running
kubectl get pod -n kube-system -l k8s-app=kube-dns
```

---

## Slow Image Pull

**Problem:** Image takes too long to download

**Solution:**

Use lite variant (15 MB vs 48 MB):

```bash
kubectl run debugbox-lite --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-lite
```

Or pre-pull on nodes:

```bash
docker pull ghcr.io/ibtisam-iq/debugbox:latest
```

---

## Out of Disk Space

**Problem:** Container filesystem full

**Solution:**

- Use lite variant (smaller) or
- Debug on different node with more space:

```bash
kubectl run debugbox --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --overrides='{"spec":{"nodeName":"node-with-space"}}'
```

---

## Debugging Multi-Container Pods

**Problem:** Not sure which container to debug

**Solution:**

```bash
# List containers
kubectl get pod my-pod -o jsonpath='{.spec.containers[*].name}'

# Debug specific container
kubectl debug my-pod -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --target=my-container
```

---

## Still Stuck?

- Check [Common Workflows](../usage/workflows.md)
- Review [Kubernetes Usage](../usage/kubernetes.md)
- Open GitHub issue with details
