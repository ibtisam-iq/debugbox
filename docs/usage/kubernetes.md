# Kubernetes Usage

DebugBox is designed for Kubernetes-native debugging workflows.

## Debug a Running Pod (Recommended)

```bash
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox
```

Shares network and process namespace with the target pod.

Target specific container in multi-container pod:
```bash
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox --target=sidecar
```

## Standalone Debugging Pod

```bash
kubectl run debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never
```

## Node-Level Debugging

```bash
kubectl run debug-node --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --overrides='{"spec":{"hostNetwork":true, "nodeName":"my-node"}}' \
  --restart=Never
```

## Persistent Sidecar Pattern

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
    image: ghcr.io/ibtisam-iq/debugbox
    command: ["sleep", "infinity"]
```

Access:
```bash
kubectl exec -it app-with-debug -c debugbox -- bash
```

## Variant Recommendations

- **lite**: Fast DNS/network checks
- **balanced** (default): Most debugging tasks
- **power**: When you need `tshark`, `nftables`, or `ltrace`

→ Real-world debugging recipes: **[Examples](../guides/examples.md)**
