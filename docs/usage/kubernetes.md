# Kubernetes Usage

DebugBox is Kubernetes-native and optimized for ephemeral debugging workflows.

!!! tip "Practice in a live playground"
    Work through real debugging scenarios with all three variants (no setup needed):
    **[Kubernetes Debugging with DebugBox →](https://labs.iximiuz.com/tutorials/kubernetes-debugging-with-debugbox-74e481c8)**

## Debug a Running Pod (Most Common)

Attach a debugging container to an existing pod:

```bash
# Default (balanced variant)
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox

# Specific variant
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:lite
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:power

# Production (pinned version)
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:1.2.0
```

Shares the pod's network namespace.

## Standalone Debugging Pod

Create a temporary debugging pod:

```bash
kubectl run debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never
```

Exit with `exit` or `Ctrl+C` to delete the pod.

## Ready-Made Pod Manifests

For declarative `kubectl apply -f` workflows, pre-made manifests are available for each variant:

| Variant | Manifest | Capabilities |
|---------|----------|---------------|
| lite | [lite-debug-pod.yaml](https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/lite-debug-pod.yaml) | None |
| balanced | [balanced-debug-pod.yaml](https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/balanced-debug-pod.yaml) | `NET_RAW` (for `tcpdump`) |
| power | [power-debug-pod.yaml](https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/power-debug-pod.yaml) | `NET_ADMIN`, `NET_RAW` |

```bash
kubectl apply -f \
  https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/lite-debug-pod.yaml
kubectl wait pod/debug-lite --for=condition=Ready --timeout=60s
kubectl exec -it debug-lite -- ash -l

kubectl apply -f \
  https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/balanced-debug-pod.yaml
kubectl wait pod/debug-balanced --for=condition=Ready --timeout=60s
kubectl exec -it debug-balanced -- bash -l

kubectl apply -f \
  https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/power-debug-pod.yaml
kubectl wait pod/debug-power --for=condition=Ready --timeout=60s
kubectl exec -it debug-power -- bash -l
```

## Power Variant with Capabilities

**Note:** For advanced networking tools (`tshark`, `conntrack`, `nft`, `iptables`), use a manifest with capabilities:

### Apply Pre-Made Manifest (Recommended)
```bash
kubectl apply -f \
  https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/power-debug-pod.yaml
kubectl wait pod/debug-power --for=condition=Ready --timeout=60s
kubectl exec -it debug-power -- bash -l
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
    command: ["/bin/bash", "-l"]
    securityContext:
      capabilities:
        add:
        - NET_ADMIN
        - NET_RAW
    tty: true
    stdin: true
  restartPolicy: Never
  terminationGracePeriodSeconds: 0
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

**Note:** kubectx/kubens require a kubeconfig to be available inside the pod (e.g., mounted at `/root/.kube/config`).

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
    image: ghcr.io/ibtisam-iq/ibtisam-iq:latest
    ports:
    - containerPort: 8080
  - name: debugbox
    image: ghcr.io/ibtisam-iq/debugbox:1.2.0
    command: ["sleep", "infinity"]
    tty: true
    stdin: true
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
    image: ghcr.io/ibtisam-iq/ibtisam-iq:latest
    ports:
    - containerPort: 8080
  - name: debugbox
    image: ghcr.io/ibtisam-iq/debugbox:power
    command: ["sleep", "infinity"]
    tty: true
    stdin: true
    securityContext:
      capabilities:
        add:
        - NET_ADMIN
        - NET_RAW
```

Access:
```bash
kubectl exec -it app-with-debug -c debugbox -- bash -l
kubectl exec -it app-with-debug-power -c debugbox -- bash -l
```

→ **[Which variant to use?](../variants/overview.md)**

## Production Best Practices

1. **Always pin versions:**
   ```bash
   --image=ghcr.io/ibtisam-iq/debugbox:1.2.0
   ```
   Never use `:latest` in production manifests.

2. **Delete after use:**
   ```bash
   kubectl delete pod debug-session
   kubectl delete pod debug-power
   ```

3. **Prefer ephemeral containers** (kubectl debug) over persistent sidecars for minimal impact.

4. **Only add capabilities when needed.** Standard kubectl debug doesn't need them.

→ **[Docker Usage](docker.md)** | **[Real-world Examples](../guides/examples.md)** | **[Troubleshooting](../guides/troubleshooting.md)**
