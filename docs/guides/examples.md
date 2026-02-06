# Examples

Real-world debugging scenarios covering **every tool** in DebugBox.

---

## DNS Troubleshooting

**Tools:** `dig`, `nslookup`, `host` (bind-tools)

```bash
kubectl run dns-debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox:lite --restart=Never

# Detailed DNS query
dig my-service.default.svc.cluster.local

# Quick lookup
nslookup my-service.default.svc.cluster.local

# Simple hostname resolution
host kubernetes.default

# Check specific DNS server
dig @8.8.8.8 example.com

# Trace DNS resolution path
dig +trace example.com

# Check DNS search domains
cat /etc/resolv.conf
```

---

## Service Connectivity

**Tools:** `curl`, `wget`, `ping`, `nc` (netcat), `telnet`

```bash
kubectl run net-debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never

# HTTP endpoint testing
curl -v http://my-service:8080/health
curl -I https://example.com        # Headers only
wget -O- http://my-service/status  # Alternative HTTP client

# Basic connectivity
ping -c 4 my-service.default.svc.cluster.local

# Port testing
nc -zv my-service 8080  # Check if port is open
nc -l 9000              # Listen on port (in one terminal)
nc my-service 9000      # Connect (in another terminal)

# Test specific ports
echo "GET / HTTP/1.0\r\n" | nc example.com 80
```

---

## Network Interface & IP Configuration

**Tools:** `ip` (iproute2), `ifconfig` (legacy alternative)

```bash
kubectl debug my-app -it --image=ghcr.io/ibtisam-iq/debugbox

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

**Tools:** `ss`, `netstat`, `lsof`

```bash
kubectl debug my-app -it --image=ghcr.io/ibtisam-iq/debugbox

# Active connections
ss -tunap                 # All TCP/UDP connections with processes
ss -tulnp                 # Listening sockets only
ss -t state established   # Established TCP connections

# Legacy netstat (from procps)
netstat -tulnp            # Listening ports

# What's using a specific port?
lsof -i :8080
lsof -i TCP:80
lsof -p $(pgrep nginx)    # Files opened by nginx
```

---

## Route Tracing

**Tools:** `mtr`, `tracepath`, `tcptraceroute` (power)

```bash
kubectl run trace-debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never

# Real-time route tracing with statistics
mtr example.com
mtr -c 10 -r example.com  # 10 cycles, report mode

# Path MTU discovery
tracepath example.com

# TCP-based traceroute (power variant)
kubectl run trace-power --rm -it --image=ghcr.io/ibtisam-iq/debugbox:power --restart=Never
tcptraceroute example.com 443
```

---

## Port Scanning & Discovery

**Tools:** `nmap`, `nping` (power), NSE scripts (power)

```bash
kubectl run scan-debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never

# Basic port scan
nmap -p 80,443,8080 my-service
nmap -p- my-service  # All ports (slow)

# Service detection
nmap -sV my-service

# Power variant: Advanced scanning
kubectl run scan-power --rm -it --image=ghcr.io/ibtisam-iq/debugbox:power --restart=Never

# Custom packet crafting
nping --tcp -p 80,443 example.com
nping --icmp example.com

# NSE scripts for vulnerability detection
nmap --script vuln example.com
nmap --script http-enum my-service
```

---

## Bandwidth Testing

**Tools:** `iperf3`, `speedtest-cli` (power)

```bash
# Network performance between pods
# Server (terminal 1)
kubectl run iperf-server --image=ghcr.io/ibtisam-iq/debugbox --command -- iperf3 -s

# Client (terminal 2)
kubectl run iperf-client --rm -it --image=ghcr.io/ibtisam-iq/debugbox --command -- iperf3 -c iperf-server -t 30

# Internet bandwidth test (power variant)
kubectl run speedtest --rm -it --image=ghcr.io/ibtisam-iq/debugbox:power --restart=Never
speedtest-cli
```

---

## Bandwidth Monitoring

**Tools:** `iftop`

```bash
kubectl run monitor --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never

# Real-time bandwidth per connection
iftop -i eth0
iftop -i eth0 -n  # Don't resolve hostnames
iftop -i eth0 -P  # Show port numbers
```

---

## NIC Diagnostics

**Tools:** `ethtool`

```bash
kubectl run nic-debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never

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

### Basic Capture (All Variants)
```bash
kubectl run capture --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never

# Capture packets
tcpdump -i eth0 -w /tmp/capture.pcap port 443
tcpdump -i eth0 -n 'tcp port 80'  # Filter by port
tcpdump -i eth0 'host 10.0.0.1'   # Filter by host
```

### Advanced Analysis (Power + NET_RAW)
```bash
kubectl apply -f https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/power-debug-pod.yaml
kubectl exec -it debug-power -- bash

# Live packet analysis with tshark
tshark -i eth0 -f "port 443"
tshark -i eth0 -Y "http.request"
tshark -r /tmp/capture.pcap -Y "dns"

# Network grep
ngrep -d any "GET" tcp port 80
ngrep "mystring" tcp port 443
```

---

## Advanced TCP/UDP Tools

**Tools:** `socat`

```bash
kubectl run socat-debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never

# Port forwarding
socat TCP-LISTEN:8080,fork TCP:backend:8080

# UDP to TCP relay
socat UDP-LISTEN:53,fork TCP:dns-server:53

# Test SSL/TLS connection
socat - OPENSSL:example.com:443,verify=0

# Create simple HTTP server
echo "HTTP/1.0 200 OK\r\n\r\nHello" | socat TCP-LISTEN:8000,reuseaddr,fork STDIO
```

---

## Connectivity Testing (Parallel)

**Tools:** `fping` (power), `arping`

```bash
# Power variant
kubectl run ping-power --rm -it --image=ghcr.io/ibtisam-iq/debugbox:power --restart=Never

# Parallel ping multiple hosts
fping -a 10.0.0.1 10.0.0.2 10.0.0.3
fping -g 10.0.0.0/24  # Entire subnet
fping -u 10.0.0.0/24  # Unreachable hosts only

# ARP-level ping (layer 2)
arping -I eth0 10.0.0.1
```

---

## Process Inspection

**Tools:** `ps`, `top`, `htop`, `pstree`, `killall`, `fuser`

```bash
kubectl debug my-app -it --image=ghcr.io/ibtisam-iq/debugbox

# Process listing
ps aux
ps aux | grep nginx

# Interactive monitoring
top
htop  # Better UI

# Process tree
pstree -p
pstree -p 1  # From specific PID

# Kill by name
killall -9 nginx

# Find process using file/port
fuser -v /var/log/app.log
fuser -n tcp 8080
```

---

## System Call Tracing

**Tools:** `strace`, `ltrace` (power), `lsof`

```bash
kubectl debug my-app -it --image=ghcr.io/ibtisam-iq/debugbox

# Trace system calls
strace -p $(pgrep nginx)
strace -e trace=network -p 1234    # Network calls only
strace -e trace=file -p 1234       # File operations only
strace -c curl http://example.com  # Call summary

# Power variant: Library call tracing
kubectl exec -it debug-power -- bash
ltrace -p $(pgrep nginx)
ltrace -c curl http://example.com  # Library call summary

# Open files
lsof -p 1234
lsof /var/log/app.log              # What process has this file open?
```

---

## TLS/SSL Inspection

**Tools:** `openssl` (power)

```bash
kubectl run ssl-debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox:power --restart=Never

# Test SSL/TLS connection
openssl s_client -connect example.com:443
openssl s_client -connect example.com:443 -showcerts

# Check certificate expiry
echo | openssl s_client -connect example.com:443 2>/dev/null | openssl x509 -noout -dates

# Verify certificate
openssl verify cert.pem

# Certificate details
openssl x509 -in cert.pem -text -noout

# Generate test certificates
openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes
```

---

## Firewall & Routing (NET_ADMIN Required)

**Tools:** `iptables`, `nft` (nftables), `conntrack`

```bash
# Apply manifest with NET_ADMIN capability
kubectl apply -f https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/power-debug-pod.yaml
kubectl exec -it debug-power -- bash

# iptables inspection
iptables -L -nv
iptables -L -nv -t nat
iptables -L -nv -t mangle

# nftables (modern alternative)
nft list ruleset
nft list table inet filter

# Connection tracking
conntrack -L
conntrack -L -p tcp --dport 443
conntrack -E  # Event monitoring
```

**Docker:**
```bash
docker run --rm -it --cap-add=NET_ADMIN ghcr.io/ibtisam-iq/debugbox:power

# Same commands work
iptables -L -nv
nft list ruleset
conntrack -L
```

---

## Bridge Networking

**Tools:** `brctl` (bridge-utils) (power + NET_ADMIN)

```bash
kubectl exec -it debug-power -- bash

# List bridges
brctl show

# Show MAC address table
brctl showmacs br0

# Show STP info
brctl showstp br0
```

---

## Routing Protocols

**Tools:** `bird` (power)

```bash
# Note: BIRD is a routing daemon, typically not running in debug container
# Useful for testing BGP configurations if bird daemon is started separately

kubectl exec -it debug-power -- bash

# If bird daemon running
birdc show status
birdc show route
birdc show protocols
```

---

## Data Processing

**Tools:** `jq`, `yq`

```bash
kubectl run data-debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox:lite --restart=Never

# JSON processing
curl -s https://api.github.com/users/octocat | jq '.name'
kubectl get pods -o json | jq '.items[].metadata.name'
echo '{"name":"test"}' | jq '.name'

# YAML processing
kubectl get pod my-pod -o yaml | yq '.spec.containers[].image'
cat config.yaml | yq '.database.host'
```

---

## File Operations

**Tools:** `file`, `tar`, `gzip`, `vim`, `nano`, `less`

```bash
kubectl debug my-app -it --image=ghcr.io/ibtisam-iq/debugbox

# Identify file type
file /tmp/unknown-file
file -i /tmp/binary     # MIME type

# Archive operations
tar -czf backup.tar.gz /app/logs/
tar -xzf backup.tar.gz
tar -tzf backup.tar.gz  # List contents
gzip large-file.log
gunzip large-file.log.gz

# View compressed files
zcat file.gz | less
zgrep "error" file.gz

# Edit files
vim /etc/config.yaml
nano /etc/config.yaml   # Power variant, easier for beginners

# Page through output
ps aux | less
kubectl logs my-pod | less
```

---

## Version Control

**Tools:** `git`

```bash
kubectl run git-debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never

# Clone repository for configs
git clone https://github.com/example/configs.git
cd configs

# Check configuration
git log --oneline
git show HEAD

# Fetch specific file from repo
git archive --remote=https://github.com/example/repo HEAD:path/to/dir file.yaml | tar -x
```

---

## Python Scripting

**Tools:** `pip3` / `python3` (power)

```bash
kubectl run python-debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox:power --restart=Never

# Install packages
pip3 install requests netaddr scapy

# Quick Python debugging
python3 -c "import socket; print(socket.gethostbyname('example.com'))"
python3 -c "import requests; print(requests.get('http://example.com').status_code)"

# Interactive Python
python3
>>> import netaddr
>>> ip = netaddr.IPNetwork('10.0.0.0/24')
>>> list(ip)[:5]
```

---

## Helper Functions (Shell)

**Built-in helpers** (balanced & power variants)

```bash
kubectl run helper-demo --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never

# List listening ports
ports

# Show active connections
connections

# Display routing table
routes

# Kubernetes context info (if kubeconfig available)
k8s-info

# Pretty-print JSON
echo '{"test":"value"}' | json

# Pretty-print YAML
kubectl get pod my-pod -o yaml | yaml
```

**Power-only helpers** (require NET_RAW/NET_ADMIN):
```bash
kubectl exec -it debug-power -- bash

# Quick packet capture
sniff tcp port 443

# Capture HTTP traffic
sniff-http

# Capture DNS queries
sniff-dns

# Monitor connections
conntrack-watch

# Check TLS certificate
cert-check example.com
```

---

## ConfigMap/Secret Inspection

**Combining local kubectl with DebugBox tools:**

DebugBox doesn't include kubectl, but you can pipe from your local machine:

```bash
# Process ConfigMap with jq
kubectl get cm my-config -o json | kubectl run jq-tool --rm -i --image=ghcr.io/ibtisam-iq/debugbox:lite --restart=Never -- jq '.data'

# Decode and inspect secret certificate
kubectl get secret my-tls -o jsonpath='{.data.tls\.crt}' | base64 -d | \
  kubectl run cert-tool --rm -i --image=ghcr.io/ibtisam-iq/debugbox:power --restart=Never -- openssl x509 -text -noout
```

---

## Complete Tool Coverage Summary

### Variant: **Lite** (~14 MB)
- DNS: dig, nslookup, host
- HTTP: curl, wget
- Connectivity: ping, nc
- Data: jq, yq
- Basic IP: ip, ss (limited)

### Variant: **Balanced** (~46 MB) — *Default*
- **All Lite tools, plus:**
- Advanced networking: socat, mtr, nmap
- Monitoring: iftop, htop
- Packet capture: tcpdump
- Process tools: ps, top, pstree, killall, fuser
- Tracing: strace, lsof
- Bandwidth: iperf3
- NIC: ethtool
- Files: file, tar, gzip, vim
- Version control: git

### Variant: **Power** (~104 MB) — *Full Forensics*
- **All Balanced tools, plus:**
- Deep packet analysis: tshark, ngrep
- Advanced scanning: nping, NSE scripts
- TLS/SSL: openssl
- Routing: tcptraceroute, fping
- Library tracing: ltrace
- Firewall: iptables, nftables (need NET_ADMIN)
- Connection tracking: conntrack (need NET_ADMIN)
- Bridge tools: brctl (need NET_ADMIN)
- BGP: bird
- Bandwidth: speedtest-cli
- Editor: nano
- Scripting: Python 3 + pip3

---

## Capability Requirements Reference

| Tool | Capability | Docker | Kubernetes |
|------|-----------|--------|------------|
| **Most tools** | None | Standard run | kubectl run/debug |
| **tshark** | NET_RAW | `--cap-add=NET_RAW` | [Use manifest](https://raw.githubusercontent.com/ibtisam-iq/debugbox/main/examples/power-debug-pod.yaml) |
| **ngrep** | NET_RAW | `--cap-add=NET_RAW` | Use manifest |
| **iptables** | NET_ADMIN | `--cap-add=NET_ADMIN` | Use manifest |
| **nftables** | NET_ADMIN | `--cap-add=NET_ADMIN` | Use manifest |
| **conntrack** | NET_ADMIN | `--cap-add=NET_ADMIN` | Use manifest |
| **brctl** | NET_ADMIN | `--cap-add=NET_ADMIN` | Use manifest |

**Quick reference:**

- 🟢 **Standard debugging:** No capabilities needed (95% of use cases)
- 🟡 **Packet analysis:** NET_RAW required
- 🔴 **Firewall/routing:** NET_ADMIN required

---

→ **[Kubernetes usage](../usage/kubernetes.md)** | **[Docker usage](../usage/docker.md)** | **[Troubleshooting](troubleshooting.md)** | **[Variants overview](../variants/overview.md)**
