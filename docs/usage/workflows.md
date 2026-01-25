# Common Workflows

Real-world debugging scenarios with DebugBox.

## Test Service Connectivity

**Scenario:** Pod can't reach a service.

```bash
kubectl run debugbox --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never

# Inside debugbox
curl -v http://my-service.default.svc.cluster.local:8080
dig my-service.default.svc.cluster.local
traceroute my-service.default.svc.cluster.local
```

---

## Debug Application Pod

**Scenario:** Application pod has issues; you need to inspect its network.

```bash
# Attach ephemeral container
kubectl debug my-app-pod -it \
  --image=ghcr.io/ibtisam-iq/debugbox

# Inside debugbox (same network as app)
curl -v http://localhost:8080/health
netstat -tulpn | grep 8080
lsof -i :8080
```

---

## Capture Network Traffic

**Scenario:** Intermittent connection issues; you need packet capture.

```bash
# Use Power variant for tshark
kubectl run debugbox --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-power \
  --restart=Never

# Inside debugbox
tcpdump -i eth0 -w /tmp/capture.pcap port 443 -c 100

# Or live analysis
tshark -i eth0 -f "port 443"
```

---

## Inspect Node Network

**Scenario:** Node-level networking issue.

```bash
kubectl run debugbox-host --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --overrides='{"spec":{"hostNetwork":true}}' \
  --restart=Never

# Inside debugbox (host network)
ip route
ip neigh
iptables -L -n
netstat -tulpn
```

---

## Test DNS Resolution

**Scenario:** DNS not resolving correctly.

```bash
kubectl run debugbox-lite --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-lite \
  --restart=Never

# Inside debugbox
dig kubernetes.default.svc.cluster.local
dig my-service.default.svc.cluster.local
nslookup my-service
```

---

## Monitor Network Traffic

**Scenario:** High bandwidth usage; debug which pods/services consume it.

```bash
kubectl run debugbox --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never

# Inside debugbox
iftop -i eth0  # Watch bandwidth per source/dest
```

---

## Trace System Calls

**Scenario:** Application behaving strangely; trace system calls.

```bash
kubectl debug my-app-pod -it --image=ghcr.io/ibtisam-iq/debugbox

# Inside debugbox
# Find the app's process ID first
ps aux | grep myapp  # Assume PID 1234

# Trace system calls
strace -p 1234 -e trace=network,open,read,write
```

---

## Parse and Inspect YAML

**Scenario:** Need to inspect ConfigMap or Secret.

```bash
kubectl run debugbox-lite --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-lite \
  --restart=Never

# Inside debugbox
kubectl get cm my-config -o yaml | yq '.data'
kubectl get secret my-secret -o yaml | yq '.data | keys'
```

---

## Debug Multi-Container Pod

**Scenario:** Pod has multiple containers; debug specific container.

```bash
kubectl debug my-pod -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --target=my-container

# Inside debugbox (attached to my-container's network)
curl -v http://localhost:8080
```

---

## Persistent Sidecar Debugging

**Scenario:** Need debugging container running alongside app continuously.

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

```bash
kubectl apply -f debugbox-sidecar.yaml
kubectl exec -it app-with-debugbox -c debugbox -- bash

# Inside debugbox (shares app's network)
watch -n 1 'curl -s http://localhost/metrics'
```

---

## Test Network Performance

**Scenario:** Performance degradation; test link performance.

```bash
# Server pod
kubectl run iperf-server --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --command -- iperf3 -s

# Client pod (different terminal)
kubectl run iperf-client --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --command -- iperf3 -c iperf-server -t 10
```

---

## Check Open Ports and Connections

**Scenario:** Service not accessible; check listening ports.

```bash
kubectl debug my-app-pod -it --image=ghcr.io/ibtisam-iq/debugbox

# Inside debugbox
netstat -tulpn
# or
ss -tulpn
lsof -i -P -n
```
