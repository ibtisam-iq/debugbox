# Examples

Real-world debugging scenarios covering **every tool** in DebugBox.

!!! tip "Live Tutorial"
    The interactive tutorial covers lite, balanced, and power debugging end-to-end in a live Kubernetes cluster:
    **[Kubernetes Debugging with DebugBox →](https://labs.iximiuz.com/tutorials/kubernetes-debugging-with-debugbox-74e481c8)**

---

## DNS Troubleshooting

**Tools:** `dig`, `nslookup`, `host` (bind-tools)

!!! note "Prerequisites"
    Deploy the app and expose it as a Service (run on the local machine):
    ```bash
    kubectl run my-pod --image=ghcr.io/ibtisam-iq/ibtisam-iq:latest --port=8080
    kubectl expose pod my-pod --port=8080 --name=ibtisam-iq
    kubectl wait pod/my-pod --for=condition=Ready --timeout=60s
    ```

```bash
kubectl run dns-debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox:lite \
  --restart=Never

# Detailed DNS query
dig ibtisam-iq.default.svc.cluster.local

# Quick lookup
nslookup ibtisam-iq.default.svc.cluster.local

# Simple hostname resolution
host kubernetes.default

# Check specific DNS server
dig @8.8.8.8 ibtisam-iq.com

# Trace DNS resolution path
dig +trace ibtisam-iq.com

# Check DNS search domains
cat /etc/resolv.conf
```

---

## Service Connectivity

**Tools:** `curl`, `ping`, `nc` (netcat)

!!! note "Prerequisites"
    Same setup as DNS Troubleshooting above (Service `ibtisam-iq` on port 8080 must exist).

```bash
kubectl run net-debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never

# HTTP endpoint testing
curl -v http://ibtisam-iq:8080/
curl -I https://ibtisam-iq.com        # Headers only

# Basic connectivity
ping -c 4 ibtisam-iq.default.svc.cluster.local

# Port testing
nc -zv ibtisam-iq 8080   # Check if port is open

# Raw HTTP request to the cluster service (HTTP/1.1 requires Host header)
printf "GET / HTTP/1.1\r\nHost: ibtisam-iq\r\nConnection: close\r\n\r\n" | nc ibtisam-iq 8080
```

---

## Network Interface & IP Configuration

**Tools:** `ip` (iproute2)

!!! note "Prerequisites"
    Attach to any running pod. Uses `my-pod` from DNS section above.

```bash
kubectl debug my-pod -it \
  --image=ghcr.io/ibtisam-iq/debugbox

# Show all interfaces
ip addr
ip link show

# Routing table
ip route
ip route get 8.8.8.8  # Show route to specific IP

# ARP/Neighbor table
ip neigh

# Interface statistics
ip -s link show eth0
```

---

## Socket & Connection Analysis

**Tools:** `ss`, `lsof`

!!! note "Prerequisites"
    Use `--target=my-pod` to share the process namespace and see the app's connections.

```bash
kubectl debug my-pod -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --target=my-pod

# Active connections
ss -tunap                 # All TCP/UDP connections with processes
ss -tulnp                 # Listening sockets only
ss -t state established   # Established TCP connections

# What's using port 8080?
lsof -i :8080
lsof -i TCP:8080

# Find app PID first, then inspect its open files
ps aux
APP_PID=$(ps aux | awk 'NR==2{print $2}')
lsof -p "$APP_PID"
```

---

## Route Tracing

**Tools:** `mtr`, `tracepath`, `tcptraceroute` (power)

**Balanced variant** (`mtr`, `tracepath`):
```bash
kubectl run trace-debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never

# Real-time route tracing with statistics
mtr ibtisam-iq.com
mtr -c 10 -r ibtisam-iq.com  # 10 cycles, report mode

# Path MTU discovery
tracepath ibtisam-iq.com
```

**Power variant** (`tcptraceroute`):
```bash
kubectl run trace-power --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox:power \
  --restart=Never

tcptraceroute ibtisam-iq.com 443
```

---

## Port Scanning & Discovery

**Tools:** `nmap`, `nping`, NSE scripts (all power)

!!! note "Prerequisites"
    Same setup as DNS Troubleshooting above (Service `ibtisam-iq` on port 8080 must exist).

```bash
kubectl run scan-debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox:power \
  --restart=Never

# Basic port scan (-Pn required: Kubernetes ClusterIPs don't respond to ICMP ping probes)
nmap -Pn -p 80,443,8080 ibtisam-iq

# Service detection (scope to known port; scanning all ports hangs on filtered ClusterIP ports)
nmap -Pn -sV -p 8080 ibtisam-iq

# Custom packet crafting (against external domain)
nping --tcp -p 80,443 ibtisam-iq.com
nping --icmp ibtisam-iq.com

# NSE scripts
nmap -Pn --script http-enum ibtisam-iq
nmap -Pn --script http-headers ibtisam-iq
```

For basic port testing without the power variant, use netcat:
```bash
nc -zv ibtisam-iq 8080  # Check if port is open
```

---

## Bandwidth Testing

**Tools:** `iperf3` (power)

**Terminal 1:** start the server and expose it as a Service:
```bash
kubectl run iperf-server \
  --image=ghcr.io/ibtisam-iq/debugbox:power \
  --command -- iperf3 -s
kubectl expose pod iperf-server --port=5201
kubectl wait pod/iperf-server --for=condition=Ready --timeout=60s
```

**Terminal 2:** run the client:
```bash
kubectl run iperf-client --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox:power \
  --command -- iperf3 -c iperf-server -t 30
```

**Cleanup** (after the test):
```bash
kubectl delete pod iperf-server
kubectl delete service iperf-server
```

---

## Bandwidth Monitoring

**Tools:** `iftop` (power)

```bash
kubectl run monitor --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox:power \
  --restart=Never

# Real-time bandwidth per connection
iftop -i eth0
iftop -i eth0 -n  # Don't resolve hostnames
iftop -i eth0 -P  # Show port numbers
```

---

## NIC Diagnostics

**Tools:** `ethtool` (power)

```bash
kubectl run nic-debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox:power \
  --restart=Never

# Interface statistics
ethtool -S eth0

# Driver information
ethtool -i eth0

# Link status
ethtool eth0
```

---

## Packet Capture & Analysis

**Tools:** `tcpdump`, `tshark` (power), `ngrep` (power)

### Basic Capture (Balanced+)

`kubectl debug` shares `my-pod`'s network namespace, so `tcpdump` sees the app's actual traffic:

```bash
kubectl debug my-pod -it \
  --image=ghcr.io/ibtisam-iq/debugbox

# Capture all traffic to a file
tcpdump -i eth0 -w /tmp/capture.pcap

# Filter by port
tcpdump -i eth0 -n 'tcp port 8080'

# Filter by port 443 (if the app makes outbound HTTPS calls)
tcpdump -i eth0 -n 'tcp port 443'
```

To generate traffic while tcpdump is running, open a second terminal on the local machine:
```bash
kubectl port-forward service/ibtisam-iq 8080:8080
curl http://localhost:8080/
```

`tcpdump` needs `NET_RAW` to open a raw socket. Some clusters (Pod Security Admission, restrictive PSPs) drop it by default, causing `tcpdump: socket: Operation not permitted`. If that happens, apply the manifest that grants it explicitly:

```bash
kubectl apply -f \
  https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/balanced-debug-pod.yaml
kubectl wait pod/debug-balanced --for=condition=Ready --timeout=60s
kubectl exec -it debug-balanced -- bash -l
```

### Advanced Analysis (Power + NET_ADMIN)
```bash
kubectl apply -f \
  https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/power-debug-pod.yaml
kubectl wait pod/debug-power --for=condition=Ready --timeout=60s
kubectl exec -it debug-power -- bash -l
```

Open a second exec session to generate traffic while capture runs in the first:
```bash
kubectl exec -it debug-power -- bash -l

curl https://ibtisam-iq.com     # generates DNS + TLS traffic on port 443
curl http://ibtisam-iq:8080/    # generates plain HTTP traffic on port 8080
```

Live capture (first terminal):
```bash
# BPF filter (applied before packet decode)
tshark -i eth0 -f "port 443"

# Display filter (applied after decode)
tshark -i eth0 -Y "http.request"

# Capture to file, then read and filter
tshark -i eth0 -w /tmp/capture.pcap
tshark -r /tmp/capture.pcap -Y "dns"
tshark -r /tmp/capture.pcap -Y "http.request"
```

Network grep:
```bash
ngrep -d any "GET" tcp port 80
ngrep "Authorization" tcp port 443
```

---

## Advanced TCP/UDP Tools

**Tools:** `socat`

!!! note "Prerequisites"
    Same setup as DNS Troubleshooting above (Service `ibtisam-iq` on port 8080 must exist).

**Port forwarding:** relay incoming connections to the app service:
```bash
kubectl run socat-debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never

socat TCP-LISTEN:8080,fork TCP:ibtisam-iq:8080
```
Test from a second terminal on the local machine:
```bash
kubectl port-forward pod/socat-debug 8080:8080
curl http://localhost:8080/
```

**TLS inspection:** send an HTTP request over a raw TLS connection:
```bash
kubectl run socat-debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never

printf "GET / HTTP/1.1\r\nHost: ibtisam-iq.com\r\nConnection: close\r\n\r\n" | \
  socat - OPENSSL:ibtisam-iq.com:443,verify=0
```

**Simple HTTP server:** respond to any incoming connection with a static message:
```bash
kubectl run socat-debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never

printf "HTTP/1.0 200 OK\r\n\r\nHello\r\n" | socat TCP-LISTEN:8000,reuseaddr,fork STDIO
```
Test from a second terminal on the local machine:
```bash
kubectl port-forward pod/socat-debug 8000:8000
curl http://localhost:8000/
```

---

## Connectivity Testing (Parallel)

**Tools:** `fping` (power), `arping` (power)

!!! note "Prerequisites"
    Collect pod IPs and the node pod CIDR on the local machine before entering the pod:
    ```bash
    kubectl get pods -o wide

    # Pod CIDR per node (one entry per node)
    kubectl get nodes -o jsonpath='{.items[*].spec.podCIDR}'
    ```

```bash
kubectl run ping-power --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox:power \
  --restart=Never

# Ping multiple pod IPs in parallel (IPs from kubectl get pods -o wide)
fping -a <POD_IP_1> <POD_IP_2>

# Sweep a pod subnet for alive pods; -a suppresses unreachable output (CIDR from kubectl get nodes)
fping -a -g <NODE_POD_CIDR>

# ARP-level ping to a specific pod (layer 2, requires NET_RAW)
arping -I eth0 <POD_IP>
```

---

## Process Inspection

**Tools:** `ps`, `top`, `htop`, `pstree`, `killall`, `fuser`

!!! note "Prerequisites"
    Use `--target=my-pod` to share the process namespace and see the app's processes.

```bash
kubectl debug my-pod -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --target=my-pod

# Process listing
ps aux

# Interactive process monitors
top
htop  # color-coded, tree view, sortable columns

# Process tree
pstree -p
pstree -p 1  # tree rooted at PID 1

# List PID and command name for all processes
ps aux | awk 'NR>1{print $2, $11}'

# Kill all processes matching a name
killall -9 <process-name>

# Find which process is listening on a port
fuser -n tcp 8080
```

---

## System Call Tracing

**Tools:** `strace`, `ltrace` (power), `lsof`

!!! note "Prerequisites"
    Use `--target=my-pod` to share the process namespace for tracing app system calls.

```bash
kubectl debug my-pod -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --target=my-pod

# Find the app PID
ps aux
APP_PID=$(ps aux | awk 'NR==2{print $2}')

# Trace all system calls made by the app
strace -p "$APP_PID"
strace -e trace=network -p "$APP_PID"    # Network syscalls only
strace -e trace=file -p "$APP_PID"       # File syscalls only
strace -c curl https://ibtisam-iq.com    # Syscall count summary for a command

# Open file descriptors held by the app (UID mismatch warnings are harmless; suppress with 2>/dev/null)
lsof -p "$APP_PID"
```

**Power variant: library call tracing**

`ltrace` intercepts library calls via PLT hooks and requires the target binary to be dynamically linked against glibc. It produces 0 results against musl-linked binaries (Alpine-based images). Use it when the app container is built on a glibc-based image (Debian, Ubuntu, Red Hat).

Attach to a running app process (glibc-based app containers only):
```bash
kubectl debug my-pod -it \
  --image=ghcr.io/ibtisam-iq/debugbox:power \
  --target=my-pod

ps aux
APP_PID=$(ps aux | awk 'NR==2{print $2}')
ltrace -p "$APP_PID"
ltrace -c curl https://ibtisam-iq.com   # Library call count summary for a command
```

---

## TLS/SSL Inspection

**Tools:** `openssl` (balanced+)

```bash
kubectl run ssl-debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never

# Test SSL/TLS connection (waits for stdin; press Ctrl+C to exit)
openssl s_client -connect ibtisam-iq.com:443
openssl s_client -connect ibtisam-iq.com:443 -showcerts

# Check certificate expiry
echo | openssl s_client -connect ibtisam-iq.com:443 2>/dev/null | openssl x509 -noout -dates

# Generate a self-signed certificate (-subj avoids interactive prompts)
openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes \
  -subj '/CN=example.com'

# Verify the generated certificate against the system trust store
openssl verify cert.pem

# Inspect certificate details
openssl x509 -in cert.pem -text -noout
```

---

## Firewall & Routing (NET_ADMIN Required)

**Tools:** `iptables`, `nft` (nftables), `conntrack`

```bash
kubectl apply -f \
  https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/power-debug-pod.yaml
kubectl wait pod/debug-power --for=condition=Ready --timeout=60s
kubectl exec -it debug-power -- bash -l

# iptables inspection
iptables -L -nv
iptables -L -nv -t nat
iptables -L -nv -t mangle

# nftables (requires nf_tables kernel module; not available on all clusters)
nft list ruleset
nft list table inet filter

# Connection tracking
conntrack -L
conntrack -L -p tcp --dport 443   # Filter to TCP connections on destination port 443
conntrack -E                       # Event monitoring
```

**Docker:**
```bash
docker run --rm -it --cap-add=NET_ADMIN ghcr.io/ibtisam-iq/debugbox:power

iptables -L -nv
nft list ruleset
conntrack -L
```

---

## Data Processing

**Tools:** `jq`, `yq`

```bash
kubectl run data-debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox:lite \
  --restart=Never

# JSON processing
curl -s https://api.github.com/repos/ibtisam-iq/debugbox | jq '{name: .name, stars: .stargazers_count}'
echo '{"name":"debugbox","port":8080}' | jq '.port'

# YAML processing (inline)
printf 'name: debugbox\nport: 8080\nenv: production\n' | yq '.name'
```

---

## File Operations

**Tools:** `file`, `tar`, `gzip`, `vim`, `less`

!!! note "Prerequisites"
    Attach to `my-pod` to inspect its filesystem.

```bash
kubectl debug my-pod -it \
  --image=ghcr.io/ibtisam-iq/debugbox

# Identify file types using files present in every container
file /usr/bin/curl        # ELF binary
file /etc/resolv.conf     # ASCII text, MIME type

# Create a test file, then archive and compress it
echo "log entry" > /tmp/app.log
tar -czf /tmp/backup.tar.gz /tmp/app.log
tar -tzf /tmp/backup.tar.gz   # List archive contents
tar -xzf /tmp/backup.tar.gz -C /tmp/

# Compress, inspect, search, decompress
gzip /tmp/app.log             # produces /tmp/app.log.gz
zcat /tmp/app.log.gz | less
zgrep "log" /tmp/app.log.gz
gunzip /tmp/app.log.gz        # restores /tmp/app.log

# Edit files
vim /etc/resolv.conf

# Page through output
ps aux | less
```

---

## Version Control

**Tools:** `git`

```bash
kubectl run git-debug --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never

# Clone repository for configs
git clone https://github.com/ibtisam-iq/debugbox.git
cd debugbox

# Check configuration
git log --oneline
git show HEAD

# Fetch a specific file from GitHub (git archive does not work over HTTPS)
curl -fsSL https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/power-debug-pod.yaml \
  -o power-debug-pod.yaml
```

---

## Helper Functions (Shell)

**Built-in helpers** (balanced & power variants)

```bash
kubectl run helper-demo --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never

# List listening ports
ports

# Show active connections
connections

# Display routing table
routes

# Kubernetes context info (if kubeconfig available)
k8s-info

# Pretty-print JSON
echo '{"name":"debugbox","port":8080}' | json

# Pretty-print YAML
printf 'name: debugbox\nport: 8080\nenv: production\n' | yaml
```

**Packet capture and TLS helpers** (balanced+):
```bash
kubectl run helper-demo --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox \
  --restart=Never

sniff tcp port 8080   # Quick packet capture filtered by port
sniff-http            # Capture HTTP traffic
sniff-dns             # Capture DNS queries
cert-check ibtisam-iq.com 443
```

**Power-only helpers** (require NET_ADMIN):
```bash
kubectl apply -f https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/power-debug-pod.yaml
kubectl wait pod/debug-power --for=condition=Ready --timeout=60s
kubectl exec -it debug-power -- bash -l

# List active conntrack entries
conntrack-watch
```

---

## ConfigMap/Secret Inspection

DebugBox does not include `kubectl`, but Kubernetes resource data can be piped into it from the local machine.

!!! note "Prerequisites"
    Create a ConfigMap and TLS secret (run on the local machine):
    ```bash
    kubectl create configmap app-config \
      --from-literal=host=ibtisam-iq.com \
      --from-literal=port=8080

    openssl req -x509 -newkey rsa:2048 \
      -keyout /tmp/tls.key -out /tmp/tls.crt \
      -days 365 -nodes -subj '/CN=ibtisam-iq.com'
    kubectl create secret tls app-tls --cert=/tmp/tls.crt --key=/tmp/tls.key
    ```

**Process ConfigMap with jq:**
```bash
kubectl get cm app-config -o json | kubectl run jq-tool --rm -i \
  --image=ghcr.io/ibtisam-iq/debugbox:lite \
  --restart=Never -- jq '.data'
```

**Decode and inspect TLS certificate:**
```bash
kubectl get secret app-tls -o jsonpath='{.data.tls\.crt}' | base64 -d | \
  kubectl run cert-tool --rm -i \
  --image=ghcr.io/ibtisam-iq/debugbox:balanced \
  --restart=Never -- openssl x509 -text -noout
```

---

→ **[Complete tool list per variant](../reference/manifest.md)** | **[Capability requirements](troubleshooting.md#permission-denied-tcpdump-iptables-conntrack-tshark)** | **[Kubernetes Usage](../usage/kubernetes.md)** | **[Docker Usage](../usage/docker.md)**
