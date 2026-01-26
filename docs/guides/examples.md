# Examples

Real-world debugging scenarios using DebugBox.

## 1. Service Not Reachable?

```bash
kubectl run debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never

# Inside
curl -v http://my-service.default.svc.cluster.local:8080
dig my-service.default.svc.cluster.local
nslookup my-service
```

## 2. Application Pod Network Issues

```bash
kubectl debug my-app -it --image=ghcr.io/ibtisam-iq/debugbox

# Inside (same network as app)
curl -v localhost:8080/health
ss -tulnp | grep 8080
lsof -i :8080
```

## 3. Capture Traffic for Offline Analysis

```bash
kubectl run capture --rm -it --image=ghcr.io/ibtisam-iq/debugbox-power --restart=Never

tcpdump -i eth0 -w /tmp/capture.pcap port 443 -c 500
# Ctrl+C, then:
kubectl cp capture:/tmp/capture.pcap ./capture.pcap -c capture
```

Or live analysis:
```bash
tshark -i eth0 -f "port 443" -Y "http"
```

## 4. Node-Level Networking Problem

```bash
kubectl run node-debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-power \
  --overrides='{"spec":{"hostNetwork":true}}' \
  --restart=Never

ip route
iptables -L -nv
nft list ruleset
conntrack -L
```

## 5. Trace Application System Calls

```bash
kubectl debug my-app -it --image=ghcr.io/ibtisam-iq/debugbox

# Find PID
ps aux | grep myapp
# Trace network calls
strace -p 1234 -e trace=network -f
```

## 6. DNS Resolution Failure

```bash
kubectl run dns-check --rm -it --image=ghcr.io/ibtisam-iq/debugbox-lite --restart=Never

dig +short my-service.default.svc.cluster.local
cat /etc/resolv.conf
nslookup kubernetes.default
```

## 7. High Bandwidth Usage

```bash
kubectl run monitor --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never

iftop -i eth0
# or per-connection
nload eth0
```

## 8. Network Performance Test

```bash
# Server
kubectl run iperf-server --image=ghcr.io/ibtisam-iq/debugbox --command -- iperf3 -s

# Client (new terminal)
kubectl run iperf-client --rm --image=ghcr.io/ibtisam-iq/debugbox --command -- iperf3 -c iperf-server.pod.ip -t 30
```

## 9. Inspect ConfigMap/Secret Content

DebugBox does **not** include `kubectl` — it focuses purely on debugging tools inside the container.

### Option A: Pipe from Workstation (Recommended)

Run `kubectl` on your local machine and pipe into DebugBox:

```bash
kubectl get cm my-config -o yaml | \
  kubectl run tools --rm -it --image=ghcr.io/ibtisam-iq/debugbox-lite --restart=Never -- yq '.data'
```

For secrets:
```bash
kubectl get secret my-tls -o jsonpath='{.data.tls\.crt}' | base64 -d | \
  kubectl run cert-view --rm -it --image=ghcr.io/ibtisam-iq/debugbox-lite --restart=Never -- openssl x509 -text -noout
```

### Option B: Mount Kubeconfig (Advanced)

If you need `kubectl` inside:

```bash
kubectl run tools --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-balanced \
  --overrides='{
    "spec": {
      "containers": [{
        "name": "tools",
        "volumeMounts": [{"name": "kubeconfig", "mountPath": "/root/.kube"}]
      }],
      "volumes": [{
        "name": "kubeconfig",
        "hostPath": {"path": "/root/.kube", "type": "Directory"}
      }]
    }
  }' \
  --restart=Never
```

Then inside:
```bash
kubectl get cm my-config -o yaml | yq '.data'
```

**Warning:** This requires hostPath access and is not recommended in restricted clusters.

→ More usage patterns: **[Kubernetes Usage](../usage/kubernetes.md)** | **[Docker Usage](../usage/docker.md)**
