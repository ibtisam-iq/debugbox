# Kubernetes Usage

DebugBox is optimized for Kubernetes debugging workflows.

## Debug Running Pod (Recommended)

Attach an ephemeral container to an existing pod:

```bash
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox
```

This shares the network namespace with the target pod, allowing you to inspect its network stack without modifying the pod itself.

### Debug Specific Container

If a pod has multiple containers, debug a specific one:

```bash
kubectl debug my-pod -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --target=my-container
```

---

## Run Temporary Debugging Pod

Spin up a temporary pod for debugging:

```bash
kubectl run debugbox --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never
```

The `--rm` flag automatically deletes the pod when you exit.

---

## Host Network Debugging

Access the node's network namespace:

```bash
kubectl run debugbox-host --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --overrides='{"spec":{"hostNetwork":true}}' \
  --restart=Never
```

Inside this pod, you can inspect host-level networking, routing tables, and firewall rules.

---

## Node Debugging

Debug a specific node:

```bash
kubectl run debugbox-node-<node-name> --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --overrides='{"spec":{"hostNetwork":true,"nodeName":"<node-name>"}}' \
  --restart=Never
```

Replace `<node-name>` with your target node name.

---

## Sidecar Debugging

Deploy DebugBox as a sidecar container:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-with-debugbox
spec:
  containers:
  - name: app
    image: nginx:alpine
    ports:
    - containerPort: 80
  
  - name: debugbox
    image: ghcr.io/ibtisam-iq/debugbox
    command: ["sleep", "infinity"]
```

Both containers share the pod's network namespace:

```bash
kubectl exec -it app-with-debugbox -c debugbox -- bash

# Inside debugbox (same network as app)
curl localhost:80
netstat -tulpn
tcpdump -i eth0
```

---

## Variant Selection

Choose the right variant for your workflow:

```bash
# Fast network check (lite)
kubectl run debugbox --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-lite

# General debugging (balanced, recommended)
kubectl debug my-pod -it \
  --image=ghcr.io/ibtisam-iq/debugbox

# Deep forensics (power)
kubectl run debugbox --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-power
```

---

## Tag Selection

Use semantic version tags for reproducibility:

```bash
# Pinned version (recommended for production)
--image=ghcr.io/ibtisam-iq/debugbox:{{ git.tag or git.describe }}

# Latest stable
--image=ghcr.io/ibtisam-iq/debugbox:latest
```

---

## Common Patterns

### Test Service Connectivity

```bash
kubectl run debugbox --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never

# Inside
curl -v http://my-service.default.svc.cluster.local:8080
dig my-service.default.svc.cluster.local
```

### Capture Network Traffic

```bash
kubectl run debugbox --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-power \
  --restart=Never

# Inside
tcpdump -i eth0 -w /tmp/capture.pcap
# Or for analysis
tshark -i eth0
```

### Inspect Pod's System Calls

```bash
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox

# Inside (attach to running process)
strace -p <pid>
```
