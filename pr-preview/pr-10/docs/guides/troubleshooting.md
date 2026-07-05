# Troubleshooting & FAQ

## Common Issues

### Image Pull Failures

**Symptoms:** `ImagePullBackOff`, `ErrImagePull`, `FailedToResolveImage`

**Step 1: Verify image name syntax**
```bash
# Correct formats
ghcr.io/ibtisam-iq/debugbox              # balanced (default)
ghcr.io/ibtisam-iq/debugbox:lite         # lightweight
ghcr.io/ibtisam-iq/debugbox:power        # full forensics
ghcr.io/ibtisam-iq/debugbox:1.0.0        # production (pinned)
ghcr.io/ibtisam-iq/debugbox:lite-1.0.0   # lite pinned version
```

**Step 2: Check network connectivity**
```bash
# From your node, can you reach GHCR?
kubectl run net-test --rm -it --image=busybox --restart=Never -- wget -O- https://ghcr.io

# If timeout/blocked, GHCR is unreachable (firewall, proxy, DNS)
```

**Step 3: If GHCR unreachable or auth required**

- **Option A:** Configure image pull secret for `ghcr.io`
  ```bash
  kubectl create secret docker-registry ghcr-secret \
    --docker-server=ghcr.io \
    --docker-username=<token> \
    --docker-password=<token>

  kubectl patch serviceaccount default -p '{"imagePullSecrets":[{"name":"ghcr-secret"}]}'
  ```

- **Option B:** Use Docker Hub mirror (if available)
  ```bash
  --image=docker.io/mibtisam/debugbox
  ```

- **Option C:** Pre-pull to nodes (if you have node access)
  ```bash
  # On each node
  docker pull ghcr.io/ibtisam-iq/debugbox:lite
  ```

**Step 4: Check pod events for details**
```bash
kubectl describe pod debug-pod
# Look for "Events" section with specific error
```

---

### Tool Not Found / Command Not Found

**Symptoms:** `bash: command not found`, `vim: not found`, `tcpdump: not found`

**Cause:** Using wrong variant. Each variant has different tools.

**Solution: Pick right variant**

| Tool Missing | Variant | Image | Why |
|--------------|---------|-------|-----|
| bash, sh, ash | lite+ | Need balanced+ | Lite has only ash (minimal shell) |
| vim, git, curl | lite | Need balanced+ | Lite is ~14MB minimal |
| tcpdump, strace, lsof | lite | Need balanced+ | Lite doesn't have advanced tools |
| tshark, nftables, ltrace | balanced | Need power | Power adds forensics tools |
| bird, brctl, speedtest | balanced | Need power | Power adds advanced networking |
| iptables, conntrack | balanced* | Need power | *Available in balanced but needs NET_ADMIN capability |

**Tool availability by variant:**

| Variant | Size | Includes |
|---------|------|----------|
| **lite** | ~14 MB | curl, wget, dig, nslookup, jq, yq, ash, vi |
| **balanced** | ~46 MB | lite + bash, git, vim, tcpdump, strace, lsof, ps, top, htop, nc, socat, mtr, nmap, iperf3, and 10+ more |
| **power** | ~104 MB | balanced + tshark, ngrep, ltrace, nping, nmap-scripts, openssl, iptables, nftables, conntrack, bird, brctl, python3, nano, speedtest-cli, and more |

**Quick fix:**
```bash
# If tool not found, try balanced
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox

# If still not found, try power
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:power
```

---

### Permission Denied (tcpdump, iptables, conntrack, tshark)

**Symptoms:**
```
tcpdump: permission denied
iptables: permission denied
conntrack v1.4.8: Operation failed: sorry, you must be root or get CAP_NET_ADMIN capability
tshark: Couldn't run dumpcap in child process: Operation not permitted
```

**Root cause:** Missing Linux capabilities (NET_ADMIN, NET_RAW)

**Quick diagnosis:**
```bash
# Which capability do you need?
tshark, ngrep, iptables, nftables, conntrack, brctl → NET_ADMIN

# Check current capabilities
grep Cap /proc/self/status
```

**Solutions (in priority order):**

**Option 1: Use manifest with capabilities (Recommended)**
```bash
kubectl apply -f https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/power-debug-pod.yaml
kubectl exec -it debug-power -- bash

# Now these work:
tshark -i eth0
iptables -L -nv
conntrack -L
```

**Option 2: Add capabilities to kubectl run**
```bash
# For packet capture
kubectl run debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox:power \
  --overrides='{"spec":{"containers":[{"name":"debug","securityContext":{"capabilities":{"add":["NET_RAW"]}}}]}}' \
  --restart=Never

# For firewall tools
kubectl run debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox:power \
  --overrides='{"spec":{"containers":[{"name":"debug","securityContext":{"capabilities":{"add":["NET_ADMIN"]}}}]}}' \
  --restart=Never
```

**Option 3: Docker equivalent**
```bash
docker run --rm -it --cap-add=NET_RAW --cap-add=NET_ADMIN ghcr.io/ibtisam-iq/debugbox:power
```

---

### Container Exits Immediately

**Symptoms:** Pod runs for 1 second and exits. `Status: Completed` but you wanted interactive shell.

**Cause 1: Missing `-it` flags**
```bash
# ❌ Wrong - pod exits immediately
kubectl run debug --image=ghcr.io/ibtisam-iq/debugbox --restart=Never

# ✅ Correct - keeps container running
kubectl run debug -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never
```

**Cause 2: Wrong command**
```bash
# ❌ Pod exits when `sleep 5` finishes
kubectl run debug -it --image=ghcr.io/ibtisam-iq/debugbox --command -- sleep 5

# ✅ Keep running
kubectl run debug -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never
```

---

### kubectl debug Not Working

**Symptoms:** `kubectl debug: command not found` or `error: debug is not a kubectl command`

**Cause:** kubectl debug is only available in Kubernetes 1.23+

**Check version:**
```bash
kubectl version --short
# Output: v1.23.0 or higher needed
```

**Solutions:**

**If K8s < 1.23:** Use kubectl run instead
```bash
# Instead of:
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox

# Use:
kubectl run debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never
```

**If kubectl is old:** Update kubectl locally
```bash
# macOS
brew upgrade kubernetes-cli

# Linux
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Windows
choco upgrade kubernetes-cli
```

---

### DNS Not Working Inside Container

**Symptoms:**
```bash
dig example.com → timeout/SERVFAIL
nslookup kubernetes.default → no answer
curl http://my-service.default.svc.cluster.local → Connection refused
```

**Step 1: Check resolv.conf**
```bash
cat /etc/resolv.conf
# Should show cluster DNS server (usually 10.96.0.10 for minikube)
```

**Step 2: Test specific DNS server**
```bash
dig @10.96.0.10 kubernetes.default
dig @8.8.8.8 google.com  # If you can reach internet
```

**Step 3: If DNS broken, check cluster**
```bash
# From your local machine:
kubectl get pods -n kube-system | grep coredns
kubectl logs -n kube-system <coredns-pod-name>

# Check if CoreDNS service exists
kubectl get svc -n kube-system kube-dns
```

**Step 4: Quick workaround**
```bash
# Add manual DNS entry inside container
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
dig google.com  # Should work now

# Or use IP directly if you have it
curl http://10.1.2.3:8080/health  # Instead of hostname
```

---

### Slow Image Pull

**Symptoms:** Pod takes 30+ seconds to start, image pull takes most of time

**Option 1: Use lite (fastest)**
```bash
--image=ghcr.io/ibtisam-iq/debugbox:lite  # 14 MB (~1-2 seconds)
```

**Option 2: Pre-pull image to nodes** (for frequent use)
```bash
# Manually on each node
docker pull ghcr.io/ibtisam-iq/debugbox:lite

# Or via DaemonSet (automatic on all nodes)
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: debugbox-prepull
  namespace: kube-system
spec:
  selector:
    matchLabels:
      app: debugbox-prepull
  template:
    metadata:
      labels:
        app: debugbox-prepull
    spec:
      containers:
      - name: prepull
        image: ghcr.io/ibtisam-iq/debugbox:lite
        command: ["sleep", "999999"]
      terminationGracePeriodSeconds: 0
EOF

# Clean up when done
kubectl delete daemonset debugbox-prepull -n kube-system
```

**Option 3: Check network**
```bash
# From your node, test GHCR connection
docker pull ghcr.io/ibtisam-iq/debugbox:lite

# If slow, could be:
# - Firewall/proxy slowing downloads
# - Regional GHCR mirror slow
# - Network congestion
```

---

### Architecture Mismatch (ARM64 nodes)

**Symptoms:** `exec format error`, pod fails to run on ARM nodes

**Status:** NOT AN ISSUE - DebugBox images are multi-arch

**Verification:**
```bash
# Check your node architecture
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.nodeInfo.architecture}{"\n"}{end}}'

# All DebugBox variants support:
# - amd64 (Intel/AMD)
# - arm64 (Apple Silicon, AWS Graviton, Raspberry Pi)

# Images include both architectures
docker buildx build --platform linux/amd64,linux/arm64 -t debugbox .
```

**If you still get exec format error:**
```bash
# Check if you're actually on the right architecture
uname -m

# If mismatch, the image might be corrupted - try re-pulling
docker rmi ghcr.io/ibtisam-iq/debugbox:lite
docker pull ghcr.io/ibtisam-iq/debugbox:lite
```

---

### "No such file or directory" on vim/nano commands

**Symptoms:** `vim: command not found` (when you use lite) but you swear you saw it before

**Cause:** Using lite variant. Lite only has `vi`, not full `vim`

**Solution:**
```bash
# Lite has minimal vi
--image=ghcr.io/ibtisam-iq/debugbox:lite → vi only

# Use balanced for full vim
--image=ghcr.io/ibtisam-iq/debugbox → vim available

# Use power for nano too
--image=ghcr.io/ibtisam-iq/debugbox:power → vim + nano
```

---

## Frequently Asked Questions

**Q: Does DebugBox include kubectl?**
A: No — intentionally. DebugBox is for low-level debugging inside containers. Use `kubectl` locally and pipe output to DebugBox if needed.

**Q: Can I run as non-root?**
A: Yes. Most tools work fine as non-root. Only tools needing raw sockets (tshark) or system access (strace, iptables) require root/capabilities.

**Q: Why no helm, k9s, or kustomize?**
A: DebugBox focuses on debugging inside containers (network, processes, files). Deployment/management tools are out of scope.

**Q: Does DebugBox work with Kubernetes 1.18?**
A: Yes for most things. `kubectl debug` requires 1.23+. Use `kubectl run` for older clusters.

**Q: Can I use DebugBox outside Kubernetes?**
A: Absolutely. It's just a Docker container:
```bash
docker run -it ghcr.io/ibtisam-iq/debugbox
docker run -it ghcr.io/ibtisam-iq/debugbox:lite
docker run -it ghcr.io/ibtisam-iq/debugbox:power
```

**Q: When should I use each variant?**

- **Lite:** You only need DNS/HTTP checks (saves bandwidth)
- **Balanced:** Default for most debugging (best balance)
- **Power:** You need packet analysis, firewall debugging, or Python scripting

**Q: What's included in lite?**
A: curl, wget, dig, nslookup, host, jq, yq, ash, vi, less

**Q: How do I pin versions in production?**
A: Always use specific version tags:
```bash
ghcr.io/ibtisam-iq/debugbox:1.0.0
ghcr.io/ibtisam-iq/debugbox:lite-1.0.0
ghcr.io/ibtisam-iq/debugbox:power-1.0.0
```
Never use `:latest` in production manifests.

**Q: Can I extend DebugBox with my own tools?**
A: Yes, create a custom image:
```dockerfile
FROM ghcr.io/ibtisam-iq/debugbox:1.0.0
RUN apk add --no-cache my-package-name
```

**Q: How often are new versions released?**
A: As needed. Track releases:
```bash
# Check latest version
curl -s https://api.github.com/repos/ibtisam-iq/debugbox/releases/latest | jq '.tag_name'

# Or visit
https://github.com/ibtisam-iq/debugbox/releases
```

**Q: Does DebugBox work on Docker Desktop?**
A: Yes. `docker run -it ghcr.io/ibtisam-iq/debugbox` works on Mac/Windows/Linux.

**Q: What if I need to debug a pod that's not running?**
A: You can't attach to a crashed pod. Options:
```bash
# 1. Check logs
kubectl logs my-pod

# 2. Create a new pod with same image
kubectl run debug-pod --image=my-image --restart=Never -it

# 3. Use a sidecar pattern for permanent debugging
```

**Q: How do I share debug sessions with colleagues?**
A: Use `socat` for port forwarding:
```bash
# In debugbox pod
socat TCP-LISTEN:9000,fork TCP:target-service:8080

# Your colleague
curl localhost:9000
```

---

## Still Stuck?

**1. Check the Examples** → [Examples](examples.md) has 40+ real scenarios

**2. Check your cluster** → Is CoreDNS running? Node ready?
```bash
kubectl get nodes
kubectl get pods -n kube-system | grep coredns
```

**3. Verify image access** → Can you pull locally?
```bash
docker pull ghcr.io/ibtisam-iq/debugbox:lite
```

**4. Open GitHub issue** with:

- DebugBox variant/version used: `ghcr.io/ibtisam-iq/debugbox:power-1.0.0`
- Kubernetes version: `kubectl version --short`
- Exact command: `kubectl debug my-pod -it --image=...`
- Error message (full output, not summarized)
- Your cluster setup (minikube, EKS, GKE, etc.)

→ **[Examples](examples.md)** | **[Kubernetes Usage](../usage/kubernetes.md)** | **[Docker Usage](../usage/docker.md)** | **[GitHub Issues](https://github.com/ibtisam-iq/debugbox/issues)**
