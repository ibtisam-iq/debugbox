# Troubleshooting

This guide covers real issues encountered when running DebugBox in Kubernetes and Docker environments. Each entry follows the same structure: symptom, root cause, and a concrete fix.

**Placeholder conventions used throughout this guide:**

| Placeholder | Meaning |
|-------------|---------|
| `<SERVICE_NAME>` | Name of the Kubernetes Service being debugged |
| `<SERVICE_PORT>` | Port the Service exposes (e.g. `8080`) |
| `<POD_NAME>` | Name of the target application pod |
| `<NAMESPACE>` | Kubernetes namespace (default: `default`) |
| `<DOMAIN>` | External hostname or domain (e.g. `example.com`) |
| `<CLUSTER_DNS_IP>` | Cluster DNS server IP (find with `kubectl get svc -n kube-system kube-dns`) |
| `<NODE_POD_CIDR>` | Pod CIDR for a specific node (find with `kubectl get nodes -o jsonpath='{.items[*].spec.podCIDR}'`) |

---

## 1. Image Pull Failures

**Symptoms:** `ImagePullBackOff`, `ErrImagePull`, `FailedToResolveImage`

**Step 1: Verify the image reference**
```bash
# Valid image references
ghcr.io/ibtisam-iq/debugbox              # balanced (default)
ghcr.io/ibtisam-iq/debugbox:lite
ghcr.io/ibtisam-iq/debugbox:power
ghcr.io/ibtisam-iq/debugbox:1.2.0
ghcr.io/ibtisam-iq/debugbox:lite-1.2.0
```

**Step 2: Test GHCR reachability from inside the cluster**
```bash
kubectl run net-test --rm -it --image=busybox --restart=Never -- wget -O- https://ghcr.io
```
A timeout or connection refused indicates a firewall, proxy, or DNS issue blocking GHCR.

**Step 3: If authentication is required**
```bash
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=<github-username> \
  --docker-password=<personal-access-token>
kubectl patch serviceaccount default \
  -p '{"imagePullSecrets":[{"name":"ghcr-secret"}]}'
```

**Step 4: Check pod events for the exact error**
```bash
kubectl describe pod <POD_NAME>
# Review the Events section at the bottom
```

---

## 2. Pod and Container Startup

### Pod exits immediately after creation

**Symptom:** Pod reaches `Completed` status within seconds.

**Cause:** Without a terminal attached (`-it`), the shell (bash or ash) finds no stdin and exits immediately.

**Fix:**
```bash
kubectl run debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never
```
The `-it` flags allocate a pseudo-TTY and keep stdin open.

---

### `error: unable to upgrade connection: container not found`

**Symptom:** `kubectl exec` fails immediately after `kubectl apply`.

**Cause:** The pod has been scheduled but the container has not finished starting. `kubectl exec` connects to the container runtime directly; if the container is not yet running, the connection is refused.

**Fix:** Always wait for readiness before exec:
```bash
kubectl apply -f examples/power-debug-pod.yaml
kubectl wait pod/debug-power --for=condition=Ready --timeout=60s
kubectl exec -it debug-power -- bash -l
```

---

### Pod takes 30 seconds to delete

**Symptom:** `kubectl delete pod` blocks for 30 seconds before the pod disappears.

**Cause:** Kubernetes sends SIGTERM and waits `terminationGracePeriodSeconds` (default: 30) before force-killing. bash does not exit on SIGTERM, so the full wait always elapses.

**Fix:** The pre-built manifests in [`examples/`](https://github.com/ibtisam-iq/debugbox/blob/main/examples) include `terminationGracePeriodSeconds: 0`. For `kubectl run` pods, add it via overrides:
```bash
kubectl run debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never \
  --overrides='{"spec":{"terminationGracePeriodSeconds":0}}'
```

---

## 3. Shell Environment and Tool Availability

### Built-in helpers not found (`ports`, `routes`, `connections`, `sniff`, etc.)

**Symptom:** Helper commands are missing even though the correct variant is running.

**Cause:** Without the `-l` (login) flag, bash and ash skip `/etc/profile.d/`, where DebugBox registers all helper functions.

**Fix:** Always pass `-l` when opening a shell:
```bash
# Balanced and power variants
kubectl exec -it <POD_NAME> -- bash -l

# Lite variant
kubectl exec -it <POD_NAME> -- ash -l

# kubectl debug sessions
kubectl debug <POD_NAME> -it --image=ghcr.io/ibtisam-iq/debugbox -- bash -l
```

---

### Tool not found (`bash: <tool>: not found`)

**Cause:** The tool belongs to a heavier variant than the one currently running.

| Tool | Minimum variant required |
|------|--------------------------|
| `ash`, `curl`, `dig`, `nc`, `ping`, `jq`, `yq`, `vi` | lite |
| `bash`, `git`, `vim`, `openssl`, `tcpdump`, `strace`, `lsof`, `htop`, `socat`, `mtr` | balanced |
| `tshark`, `ngrep`, `ltrace`, `nmap`, `nping`, `iperf3`, `iptables`, `conntrack`, `nft` | power |

**Fix:** Switch to the appropriate variant:
```bash
# Upgrade to balanced
kubectl debug <POD_NAME> -it --image=ghcr.io/ibtisam-iq/debugbox

# Upgrade to power
kubectl debug <POD_NAME> -it --image=ghcr.io/ibtisam-iq/debugbox:power
```

---

## 4. DNS Resolution

### `dig` / `nslookup` / `curl` cannot resolve hostnames

**Symptoms:** `dig <SERVICE_NAME>` returns SERVFAIL or times out; `curl http://<SERVICE_NAME>:<SERVICE_PORT>/` fails with "Could not resolve host".

**Step 1: Inspect the container's resolver configuration**
```bash
cat /etc/resolv.conf
# The nameserver line should point to the cluster DNS server
# On kubeadm clusters this is commonly 10.96.0.10; on other distributions it varies
```

**Step 2: Test the cluster DNS server directly**
```bash
# Replace <CLUSTER_DNS_IP> with the nameserver from /etc/resolv.conf
dig @<CLUSTER_DNS_IP> <SERVICE_NAME>.<NAMESPACE>.svc.cluster.local
dig @<CLUSTER_DNS_IP> kubernetes.default.svc.cluster.local
```

**Step 3: Check CoreDNS health from the local machine**
```bash
kubectl get pods -n kube-system -l k8s-app=kube-dns
kubectl logs -n kube-system <coredns-pod-name>
```

**Temporary workaround inside the container:**
```bash
# Add a public resolver; changes are lost when the pod restarts
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
```

---

## 5. Service Connectivity

### Internal cluster Service not reachable from the local machine

**Symptom:** `curl http://<SERVICE_NAME>:<SERVICE_PORT>/` fails with "Could not resolve host" when run from the local machine.

**Cause:** Kubernetes Service DNS names (`<SERVICE_NAME>.<NAMESPACE>.svc.cluster.local`) are only resolvable inside the cluster network.

**Fix:** Use `kubectl port-forward` to proxy the Service to a local port:
```bash
kubectl port-forward service/<SERVICE_NAME> <SERVICE_PORT>:<SERVICE_PORT>
curl http://localhost:<SERVICE_PORT>/
```
Keep the port-forward running in a separate terminal while generating traffic.

---

### Pod-to-pod bandwidth test fails with "Connection refused"

**Symptom:** `iperf3 -c <pod-name>` from a client pod is refused immediately.

**Cause:** Pod names are not DNS-resolvable inside the cluster. DNS resolution in Kubernetes requires a Service object; bare pod names have no DNS entry.

**Fix:** Expose the server pod as a Service before running the client:
```bash
kubectl run iperf-server \
  --image=ghcr.io/ibtisam-iq/debugbox:power \
  --command -- iperf3 -s
kubectl expose pod iperf-server --port=5201
kubectl wait pod/iperf-server --for=condition=Ready --timeout=60s

# Client can now resolve "iperf-server" via cluster DNS
kubectl run iperf-client --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox:power \
  --command -- iperf3 -c iperf-server -t 30
```
This principle applies to any pod-to-pod DNS resolution: a pod name alone is not addressable; a Service is required.

---

### Raw HTTP request returns a proxy error (403, 421, or similar)

**Symptom:** Sending a raw HTTP/1.0 request via `nc` or `socat` to a hostname behind a reverse proxy or CDN returns an error page instead of the expected response.

**Cause:** HTTP/1.0 does not include a `Host` header. Reverse proxies and CDNs (Cloudflare, AWS CloudFront, GCP Load Balancer) use the `Host` header to route requests to the correct backend. Without it, the proxy cannot identify the target virtual host and returns an error.

**Fix:** Use HTTP/1.1 and include an explicit `Host` header:
```bash
# For an external domain
printf "GET / HTTP/1.1\r\nHost: <DOMAIN>\r\nConnection: close\r\n\r\n" | nc <DOMAIN> 80

# For an internal cluster Service
printf "GET / HTTP/1.1\r\nHost: <SERVICE_NAME>\r\nConnection: close\r\n\r\n" | nc <SERVICE_NAME> <SERVICE_PORT>
```

---

## 6. Permissions (NET_RAW and NET_ADMIN)

### `tcpdump`, `tshark`, `iptables`, or `conntrack` return "Operation not permitted"

**Symptoms:**
```
tcpdump: socket: Operation not permitted
tshark: Couldn't run dumpcap in child process: Operation not permitted
iptables: Operation not permitted
conntrack: Operation failed: sorry, you must be root or get CAP_NET_ADMIN capability
```

**Cause:** The container is missing the Linux capabilities required by these tools.

| Tool category | Required capability |
|---------------|---------------------|
| `tcpdump`, `tshark`, `ngrep` | `NET_RAW` |
| `iptables`, `nftables`, `conntrack` | `NET_ADMIN` |

**Fix on Kubernetes:** Use the pre-built power manifest, which declares both capabilities:
```bash
kubectl apply -f \
  https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/power-debug-pod.yaml
kubectl wait pod/debug-power --for=condition=Ready --timeout=60s
kubectl exec -it debug-power -- bash -l
```

**Fix on Docker:**
```bash
docker run --rm -it \
  --cap-add=NET_RAW \
  --cap-add=NET_ADMIN \
  ghcr.io/ibtisam-iq/debugbox:power
```

**Verify current capabilities inside the container:**
```bash
grep Cap /proc/self/status
```

---

## 7. Network Debugging

### `nmap` reports "Host seems down"

**Symptom:** `nmap <SERVICE_NAME>` or `nmap <SERVICE_CLUSTER_IP>` exits with "Note: Host seems down."

**Cause:** nmap's default host discovery phase sends ICMP echo probes. Kubernetes ClusterIPs do not respond to ICMP, so nmap treats the target as unreachable before scanning a single port.

**Fix:** Pass `-Pn` to disable host discovery and scan ports directly:
```bash
nmap -Pn -p <SERVICE_PORT> <SERVICE_NAME>
nmap -Pn -p 80,443,<SERVICE_PORT> <SERVICE_NAME>
```

---

### `nmap` hangs for a very long time

**Symptom:** `nmap <SERVICE_NAME>` or `nmap -p- <SERVICE_NAME>` runs for minutes without output.

**Cause:** All ports outside the Service's exposed port set are filtered at the cluster networking layer: they silently drop packets rather than sending a reset. nmap waits for a configurable timeout on each filtered port. With a /16 port scan (65,535 ports), this takes hours.

**Fix:** Always scope nmap to known ports when targeting a ClusterIP:
```bash
# Scan only the port the Service is known to expose
nmap -Pn -p <SERVICE_PORT> <SERVICE_NAME>

# Service version detection with a port scope
nmap -Pn -sV -p <SERVICE_PORT> <SERVICE_NAME>
```

---

### `tcpdump` captures 0 packets

**Symptom:** `tcpdump -i eth0` runs without error but counts 0 packets even while traffic is flowing to the target pod.

**Cause:** `kubectl run` creates a pod with its own isolated network namespace. Traffic sent to a different pod is not visible in this namespace; the two pods have separate virtual NICs.

**Fix:** Use `kubectl debug` to attach to the target pod's network namespace. The debug container shares the pod's `eth0` interface and sees all its traffic:
```bash
kubectl debug <POD_NAME> -it \
  --image=ghcr.io/ibtisam-iq/debugbox

tcpdump -i eth0 -n 'tcp port <SERVICE_PORT>'
```

To generate traffic while capture is running, open a second terminal on the local machine:
```bash
kubectl port-forward service/<SERVICE_NAME> <SERVICE_PORT>:<SERVICE_PORT>
curl http://localhost:<SERVICE_PORT>/
```

---

### `tshark -r /tmp/capture.pcap` fails with "No such file or directory"

**Symptom:** tshark read mode fails immediately.

**Cause:** The `.pcap` file does not exist until a prior capture command writes it. tshark or tcpdump must run first.

**Fix:** Capture to a file, then read it:
```bash
# Step 1: capture traffic (Ctrl+C to stop)
tshark -i eth0 -w /tmp/capture.pcap

# Step 2: read and filter the saved capture
tshark -r /tmp/capture.pcap -Y "dns"
tshark -r /tmp/capture.pcap -Y "http.request"
```

---

### `fping -g <CIDR>` shows all hosts unreachable

**Symptom:** Sweeping a CIDR range returns only "is unreachable" lines.

**Cause:** In a multi-node cluster, each node is assigned its own pod CIDR subnet. Sweeping the wrong node's subnet (commonly the control plane's `/24`) finds no running pods because application pods are scheduled on worker nodes with different subnets.

**Fix:** Identify the correct subnet before sweeping:
```bash
# On the local machine: list pod CIDR per node
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.podCIDR}{"\n"}{end}'

# Inside the pod: sweep the correct worker node subnet
fping -a -g <NODE_POD_CIDR>
```

---

## 8. Tool-Specific Behavior

### `ltrace` reports 0 library calls

**Symptom:** `ltrace -c <command>` completes successfully but prints `0 total` in the summary.

**Cause:** `ltrace` hooks shared library calls via the PLT (Procedure Linkage Table), a glibc mechanism. DebugBox is Alpine-based and uses musl libc, which does not implement glibc's PLT ABI. No hooks fire, so ltrace sees no calls.

**When ltrace works:** Only against processes from glibc-based images (Debian, Ubuntu, Red Hat). To trace such a process, attach using `--target`:
```bash
kubectl debug <POD_NAME> -it \
  --image=ghcr.io/ibtisam-iq/debugbox:power \
  --target=<POD_NAME>

APP_PID=$(ps aux | awk 'NR==2{print $2}')
ltrace -p "$APP_PID"
```
For musl-linked processes, use `strace` instead.

---

### `nft list ruleset` fails with "No such file or directory"

**Symptom:** Any `nft` command returns `Error: No such file or directory`.

**Cause:** `nft` communicates with the kernel through the `nf_tables` subsystem. Many Kubernetes clusters run kube-proxy in iptables mode and never load the `nf_tables` kernel module, leaving the netlink socket absent.

**Workaround on affected clusters:** Use `iptables` for firewall inspection:
```bash
iptables -L -nv
iptables -L -nv -t nat
```

On Docker hosts where the kernel has nftables loaded, `nft` works correctly with `NET_ADMIN`:
```bash
docker run --rm -it --cap-add=NET_ADMIN ghcr.io/ibtisam-iq/debugbox:power
nft list ruleset
```

---

### `lsof -p <PID>` prints repeated "no pwd entry for UID N" warnings

**Symptom:** Every line of lsof output is preceded by a warning like `lsof: no pwd entry for UID 101`.

**Cause:** The application container runs as a numeric UID (e.g. 101 for the nginx user in Alpine nginx images) that does not exist in DebugBox's `/etc/passwd`. lsof cannot resolve the UID to a name and logs a warning per file descriptor.

**Behavior:** The warnings are harmless. The complete file descriptor list is still printed.

**Suppress the warnings:**
```bash
lsof -p "$APP_PID" 2>/dev/null
```

---

### `socat - OPENSSL:<host>:443` produces no output

**Symptom:** The command runs without error but prints nothing, then exits.

**Cause:** `socat -` reads from stdin and forwards to the TLS socket. When stdin reaches EOF (or nothing is typed), socat sends nothing to the server. The server waits for a request and returns nothing.

**Fix:** Pipe a complete HTTP request so the server has something to respond to:
```bash
printf "GET / HTTP/1.1\r\nHost: <DOMAIN>\r\nConnection: close\r\n\r\n" | \
  socat - OPENSSL:<DOMAIN>:443,verify=0
```

---

### `ps aux | awk 'NR==2{print $1}'` returns a UID instead of a PID

**Symptom:** `APP_PID` is set to a number like `101` (a UID) rather than a process ID.

**Cause:** The `ps aux` column order is `USER PID %CPU %MEM ...`. Column `$1` is `USER`, not `PID`.

**Fix:** Use column `$2`:
```bash
APP_PID=$(ps aux | awk 'NR==2{print $2}')
strace -p "$APP_PID"
```

---

### `openssl verify cert.pem` fails with "No such file or directory"

**Symptom:** openssl cannot open `cert.pem` even though the generate command was run.

**Cause:** The verify command was run before the generate command, or the generate command failed silently.

**Fix:** Generate the certificate first, then verify:
```bash
openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem \
  -days 365 -nodes -subj '/CN=example.com'
openssl verify cert.pem
openssl x509 -in cert.pem -text -noout
```

---

### `openssl req -x509` prompts for interactive input

**Symptom:** The command pauses and prompts for Country, State, Organization, and Common Name.

**Cause:** Without a `-subj` flag, openssl reads the Distinguished Name fields interactively.

**Fix:** Pass `-subj` to make the command non-interactive:
```bash
openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem \
  -days 365 -nodes -subj '/CN=example.com'
```

---

## Frequently Asked Questions

**Does DebugBox include kubectl?**

No. DebugBox is for low-level inspection inside running containers. Use kubectl from the local machine and pipe its output into DebugBox where needed (see [ConfigMap/Secret Inspection](examples.md#configmapsecret-inspection)).

**Can DebugBox run as non-root?**

Most tools work without root. Tools that open raw sockets (`tcpdump`, `tshark`) or modify firewall state (`iptables`, `conntrack`) require root or the appropriate Linux capability (`NET_RAW` or `NET_ADMIN`).

**Why no helm, k9s, or kustomize?**

DebugBox focuses on low-level runtime inspection: networking, processes, and filesystem. Cluster management and deployment tools are out of scope.

**Does DebugBox work on ARM64 nodes?**

Yes. All variants ship multi-arch images covering `linux/amd64` and `linux/arm64`. No platform override or node selector is needed.

**Can DebugBox be extended with additional packages?**

Yes, build a custom image from any DebugBox variant as the base:
```dockerfile
FROM ghcr.io/ibtisam-iq/debugbox:1.2.0
RUN apk add --no-cache <package-name>
```

**How can the latest released version be found?**

```bash
curl -s https://api.github.com/repos/ibtisam-iq/debugbox/releases/latest | jq -r '.tag_name'
```

---

## Still Stuck?

Open a GitHub issue and include:

- DebugBox variant and version used (e.g. `ghcr.io/ibtisam-iq/debugbox:power-1.2.0`)
- Kubernetes version: `kubectl version`
- Exact command and full error output
- Cluster type (minikube, kubeadm, EKS, GKE, AKS, etc.)

→ **[Examples](examples.md)** | **[Kubernetes Usage](../usage/kubernetes.md)** | **[Docker Usage](../usage/docker.md)** | **[GitHub Issues](https://github.com/ibtisam-iq/debugbox/issues)**
