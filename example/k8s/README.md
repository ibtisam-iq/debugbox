# Kubernetes Debug Manifests

The `k8s/` directory provides ready-to-use Kubernetes manifests for launching DebugBox in different modes.

## 1. debug-pod.yaml
A simple, non-privileged pod for everyday debugging.

Run:

```bash
kubectl apply -f debug-pod.yaml
kubectl exec -it debugbox -- bash
```

## 2. debug-pod-privileged.yaml
A privileged pod for advanced SRE-level diagnostics:

- tcpdump
- iptables / nftables
- network namespace inspection
- host filesystem access

Run:

```bash
kubectl apply -f debug-pod-privileged.yaml
kubectl exec -it debugbox-privileged -- bash
```

## 3. debug-daemonset.yaml
Deploys DebugBox on every node.

Use this when:

- You need node-level visibility
- Cluster-wide network testing
- Daemon-level debugging

Run:

```bash
kubectl apply -f debug-daemonset.yaml
```

## 4. ephemeral-debug.yaml
For Kubernetes ephemeral containers (1.18+).

Recommended modern workflow:

```bash
kubectl debug POD_NAME -it --image=ghcr.io/ibtisam-iq/debugbox:balanced
```

## 5. debug-job.yaml
Good for scripting and automation:

- connectivity tests  
- DNS resolution  
- API checks  
- periodic probes  

Run:
```bash
kubectl apply -f debug-job.yaml
kubectl logs job/debugbox-job
```

---

# Summary

These manifests make DebugBox **Kubernetes-ready out of the box**, supporting:

- Quick debugging  
- Privileged deep inspection  
- DaemonSet cluster-wide tools  
- Ephemeral debugging  
- Automated tests via Job