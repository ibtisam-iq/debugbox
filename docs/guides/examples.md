# Examples & Recipes

Real-world debugging scenarios and solutions.

## Quick Network Test

```bash
kubectl run debugbox-lite --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-lite --restart=Never

# Inside
curl -I https://kubernetes.io
dig kubernetes.default
```

## Service Discovery Check

```bash
kubectl run debugbox --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox --restart=Never

# Inside
kubectl get svc
curl http://my-service:8080
```

## Pod Network Debugging

```bash
kubectl debug my-app-pod -it \
  --image=ghcr.io/ibtisam-iq/debugbox

# Inside (same network as app pod)
curl localhost:8080
netstat -tulpn
```

## Packet Capture

```bash
kubectl run debugbox --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-power --restart=Never

# Inside
tcpdump -i eth0 -w /tmp/capture.pcap
```

## Node Network Inspection

```bash
kubectl run debugbox-host --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --overrides='{"spec":{"hostNetwork":true}}' \
  --restart=Never

# Inside (host network)
ip route
iptables -L
```

## Process Tracing

```bash
kubectl debug my-app-pod -it \
  --image=ghcr.io/ibtisam-iq/debugbox

# Inside
ps aux | grep myapp
strace -p <pid> -e trace=network
```

## DNS Troubleshooting

```bash
kubectl run debugbox-lite --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-lite --restart=Never

# Inside
dig my-service.default.svc.cluster.local
nslookup my-service
```

## Persistent Sidecar

Save this as `debugbox-sidecar.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-with-debugbox
spec:
  containers:
  - name: app
    image: nginx:alpine
  - name: debugbox
    image: ghcr.io/ibtisam-iq/debugbox
    command: ["sleep", "infinity"]
```

Then:

```bash
kubectl apply -f debugbox-sidecar.yaml
kubectl exec -it app-with-debugbox -c debugbox -- bash
```

## More Examples

See [Common Workflows](../usage/workflows.md) for detailed scenarios.
