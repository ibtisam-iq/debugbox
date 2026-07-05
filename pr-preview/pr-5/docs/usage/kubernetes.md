# Kubernetes Usage

DebugBox is Kubernetes-native and optimized for ephemeral debugging workflows.

## Debug a Running Pod (Most Common)

Attach a debugging container to an existing pod:

```bash
# Default (balanced variant)
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox

# Specific variant
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:lite
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:power

# Production (pinned version)
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:1.0.0
```

Shares network and process namespace with the target pod.

## Standalone Debugging Pod

Create a temporary debugging pod:

```bash
kubectl run debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never
```

Exit with `exit` or `Ctrl+C` to delete the pod.

## Power Variant with Capabilities

**⚠️ For advanced networking tools** (`tshark`, `conntrack`, `nft`, `iptables`), use a manifest with capabilities:

### Apply Pre-Made Manifest (Recommended)
```bash
kubectl apply -f \
  https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/power-debug-pod.yaml

kubectl exec -it debug-power -- bash
```

### Create Manually
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: debug-power
spec:
  containers:
  - name: debugbox
    image: ghcr.io/ibtisam-iq/debugbox:power
    command: ["/bin/bash"]
    securityContext:
      capabilities:
        add:
        - NET_ADMIN
        - NET_RAW
    tty: true
    stdin: true
  restartPolicy: Never
```

**Delete when done:**
```bash
kubectl delete pod debug-power
```

## Kubernetes Context Switching

DebugBox includes `kubectx` and `kubens` (balanced and power variants only):

```bash
# Inside the pod
kubectx                   # List contexts
kubectx minikube          # Switch context
kubens                    # List namespaces
kubens kube-system        # Switch namespace
kubectx -c                # Show current context
```

**Note:** Context/namespace switching works because DebugBox runs in the same network as your local kubeconfig.

## Node-Level Debugging

Debug the cluster node itself:

```bash
kubectl run node-debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --overrides='{"spec":{"hostNetwork":true}}' \
  --restart=Never
```

## Persistent Sidecar Pattern

For long-running debugging alongside your application:

### Standard Sidecar
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-with-debug
spec:
  containers:
  - name: app
    image: nginx:alpine
  - name: debugbox
    image: ghcr.io/ibtisam-iq/debugbox:1.0.0
    command: ["sleep", "infinity"]
```

### Power Sidecar with Capabilities
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-with-debug-power
spec:
  containers:
  - name: app
    image: nginx:alpine
  - name: debugbox
    image: ghcr.io/ibtisam-iq/debugbox:power
    command: ["sleep", "infinity"]
    securityContext:
      capabilities:
        add:
        - NET_ADMIN
        - NET_RAW
```

Access:
```bash
kubectl exec -it app-with-debug -c debugbox -- bash
kubectl exec -it app-with-debug-power -c debugbox -- bash
```

## Variant Recommendations

| Task | Variant | Command |
|------|---------|------------|
| Quick DNS/connectivity | lite | `kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:lite` |
| Pod debugging (default) | balanced | `kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox` |
| Packet capture | power + manifest | `kubectl apply -f power-debug-pod.yaml` |
| Routing/firewall | power + manifest | `kubectl apply -f power-debug-pod.yaml` |

## Production Best Practices

1. **Always pin versions:**
   ```bash
   --image=ghcr.io/ibtisam-iq/debugbox:1.0.0
   ```
   Never use `:latest` in production manifests.

2. **Delete after use:**
   ```bash
   kubectl delete pod debug-session
   kubectl delete pod debug-power
   ```

3. **Prefer ephemeral containers** (kubectl debug) over persistent sidecars for minimal impact.

4. **Only add capabilities when needed** — standard kubectl debug doesn't need them.

→ **[Docker Usage](docker.md)** | **[Real-world Examples](../guides/examples.md)** | **[Troubleshooting](../guides/troubleshooting.md)**
