# DebugBox



**Status & Quality**
[![CI](https://github.com/ibtisam-iq/debugbox/actions/workflows/ci.yml/badge.svg)](https://github.com/ibtisam-iq/debugbox/actions/workflows/ci.yml)
[![Documentation](https://github.com/ibtisam-iq/debugbox/actions/workflows/docs.yml/badge.svg)](https://github.com/ibtisam-iq/debugbox/actions/workflows/docs.yml)
[![Latest Release](https://img.shields.io/github/v/release/ibtisam-iq/debugbox?label=release)](https://github.com/ibtisam-iq/debugbox/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)



**Container Registries**
[![Docker Pulls](https://img.shields.io/docker/pulls/mibtisam/debugbox?logo=docker&label=Docker%20Hub&logoColor=white)](https://hub.docker.com/r/mibtisam/debugbox)
[![GitHub Container Registry](https://img.shields.io/badge/GHCR-Available-brightgreen?logo=github&logoColor=white)](https://github.com/ibtisam-iq/debugbox/pkgs/container/debugbox)
[![Multi-Arch](https://img.shields.io/badge/Multi--Arch-amd64%20%7C%20arm64-blue?logo=docker&logoColor=white)](https://github.com/ibtisam-iq/debugbox)



**Security & Platform**
[![Trivy Scanning](https://img.shields.io/badge/Security-Trivy%20Scanned-blue?logo=aqua&logoColor=white)](https://github.com/aquasecurity/trivy)
[![Powered by Alpine](https://img.shields.io/badge/Powered%20by-Alpine%20Linux-0D597F?logo=alpine-linux&logoColor=white)](https://alpinelinux.org/)
[![Kubernetes Ready](https://img.shields.io/badge/Kubernetes-Ready-326ce5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)



**Community**
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baadc.svg)](CODE_OF_CONDUCT.md)
[![GitHub Stars](https://img.shields.io/github/stars/ibtisam-iq/debugbox?style=flat&logo=github&logoColor=white)](https://github.com/ibtisam-iq/debugbox/stargazers)
[![GitHub Issues](https://img.shields.io/github/issues/ibtisam-iq/debugbox?logo=github&logoColor=white)](https://github.com/ibtisam-iq/debugbox/issues)



**Docs:** **https://debugbox.ibtisam-iq.com**



---



## The Problem



You need to debug a pod. You run `kubectl debug my-pod --image=netshoot` 
and wait for **201 MB** to download.



On an edge cluster? Mobile network? Restricted bandwidth? **Every MB costs time.**



Worse still: you just need to check DNS. You don't need tcpdump, tshark, routing tools. 
But netshoot is all-or-nothing.



---



## The Solution



**DebugBox** is a **Kubernetes-native debugging container that lets you 
choose exactly what you need—no more, no less.**



**Optimized for Kubernetes:**
- `kubectl debug` ephemeral containers — launch in seconds
- `kubectx`/`kubens` context switching — built-in cluster awareness
- Shell helpers pre-loaded — json() and yaml() functions ready to use
- Pinned tool versions — deterministic, repeatable builds



**Three sizes. Pick one:**
- **LITE** (14.36 MB): DNS & connectivity
- **BALANCED** (46.16 MB): Daily Kubernetes debugging ⭐
- **POWER** (104.45 MB): Packet analysis & forensics


**No bloat. No waiting. Right-sized for your job.**


> Sizes measured via `docker save | gzip -c | wc -c` — reflects actual compressed download size from registry.



---



## Choosing Your Variant



**Pick the right size for your task:**
```
                Need to analyze packets?
                         │
                    ┌────┴─────┐
                    │          │
                   NO         YES ──────► POWER (104.45 MB)
                    │                    (tshark, iptables, bird)
                    │
           Need tcpdump or K8s tools?
                    │
                ┌───┴────┐
                │        │
               NO       YES ─────────► BALANCED (46.16 MB) ⭐
                │                     (tcpdump, kubectx/ns)
                │
               YES ────────────────► LITE (14.36 MB)
                                    (minimal, fast)
```



---



## Quick Start



### Kubernetes (Recommended)



```bash
# Debug a running pod
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox

# Standalone debugging session
kubectl run debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never
```



---



## Why DebugBox?



### 🚀 **48% Smaller Than netshoot**



| Image | Compressed Size |
|-------|-----------------|
| DebugBox lite | 14.36 MB |
| DebugBox balanced | 46.16 MB |
| DebugBox power | 104.45 MB |
| netshoot v0.15 | 201.67 MB |



DebugBox power is **97 MB smaller** than netshoot (48% reduction).  
DebugBox lite is **14× smaller** than netshoot.


On resource-constrained clusters (edge, IoT, Kubernetes on laptops), **every MB counts**. Faster pulls mean faster debugging.



### 🔒 **Secure by Default**
- Trivy scans block HIGH/CRITICAL on every release
- Alpine Linux base (minimal attack surface)
- No unnecessary packages
- Security policy: **[SECURITY.md](SECURITY.md)**
- Runs as root by design (ephemeral containers only)



### 📦 **Multi-Architecture**
- **amd64** (Intel/AMD)
- **arm64** (Apple Silicon, AWS Graviton, Raspberry Pi)



---



## Real-World Impact



### Bandwidth: Why It Matters



**Scenario: Pulling DebugBox 50 times in a week across your cluster**



| Container | Per Pull | 50 Pulls/week | Monthly |
|-----------|----------|---------------|---------|
| netshoot | 201.67 MB | 10.08 GB | ~40 GB |
| DebugBox lite | 14.36 MB | 718 MB | ~2.8 GB |
| **Savings** | **187.31 MB** | **9.36 GB** | **37.2 GB** |



On limited bandwidth networks, this is **hours saved per month**.



### Speed: Faster Debugging



Faster pulls → faster iteration → faster incident resolution.



```
$ time kubectl debug my-pod -it --image=netshoot
real    0m16.1s   # Waiting for 201.67 MB @ 100 Mbps



$ time kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox-lite
real    0m1.15s   # Waiting for 14.36 MB @ 100 Mbps
```



---



## Features by Variant



### DebugBox Lite (14.36 MB)
**Minimal, fast-pull image for quick network diagnostics:**
- **Networking:** curl, netcat-openbsd, iproute2, iputils, bind-tools (dig, nslookup)
- **Data parsing:** jq, yq
- **Shell:** ash with json() and yaml() helpers
- **Editor:** vi



**Perfect for:** API connectivity checks, DNS resolution, basic port scanning


**Use case:** "Is the endpoint reachable? Does DNS resolve?"



### DebugBox Balanced (46.16 MB) — Recommended
**Daily-driver image for cloud-native debugging:**


*Includes all of Lite, plus:*
- **Shell & UX:** bash, bash-completion, less pager
- **Editor:** vim (vi upgrade)
- **Version Control:** git
- **Filesystem Tools:** file, tar, gzip
- **Advanced Networking:** tcpdump, socat, nmap, mtr, iperf3, ethtool, iftop
- **System Inspection:** htop, strace, lsof, procps, psmisc
- **Kubernetes Tools:** kubectx, kubens (cluster/namespace switching)



**Perfect for:** Pod networking issues, log parsing, performance analysis, cluster debugging


**Use case:** "Debug pod networking, inspect container logs, trace system calls, measure bandwidth"



### DebugBox Power (104.45 MB)
**Full SRE-grade image for deep system and network forensics:**



*Includes all of Balanced, plus:*
- **Additional Editor:** nano (alongside vim)
- **TLS/SSL Inspection:** openssl (certificate inspection and debugging)
- **Deep Packet Analysis:** tshark, tcpdump with smart helpers, ngrep (grep for network packets)
- **Advanced Network Tools:** tcptraceroute, nmap-nping, fping, speedtest-cli
- **System Internals:** ltrace (library call tracing)
- **Advanced Routing Suite:** iptables, nftables, conntrack-tools, bird, bridge-utils
- **Scripting:** py3-pip (Python package management for custom scripts)
- **Shell Helpers (comprehensive):**
  - `json()` / `yaml()` — Pretty-print JSON/YAML
  - `ports()` — List all listening ports
  - `connections()` — Show active connections
  - `routes()` — Display routing table
  - `k8s-info` — Show current K8s context & namespace
  - `sniff()` — Quick packet capture with smart filters
  - `sniff-http()` — Capture HTTP traffic (ports 80/443)
  - `sniff-dns()` — Capture DNS queries (port 53)
  - `cert-check()` — Inspect TLS certificates from servers
  - `conntrack-watch()` — Monitor active connections in real-time



**Perfect for:** Packet capture analysis, routing troubleshooting, connection tracking, certificate debugging, advanced forensics


**Use case:** "Analyze network packets, debug routing issues, trace library calls, inspect TLS certificates, write debugging scripts"



---



## Comparison to Alternatives



| Feature | DebugBox | netshoot | busybox | Alpine |
|---------|----------|----------|---------|--------|
| **Smallest variant** | 14.36 MB | 201.67 MB | 1.5 MB | 7.6 MB |
| **Variants** | ✓ 3 sizes | ✗ one size | ✗ one size | ✗ one size |
| **Multi-arch** | ✓ amd64+arm64 | ✓ amd64+arm64 | ✓ amd64+arm64 | ✓ amd64+arm64 |
| **Pinned tools** | ✓ deterministic | ✗ floating | ✗ minimal | ✗ minimal |
| **Kubernetes helpers** | ✓ kubectx/ns | ✗ none | ✗ none | ✗ none |
| **Security scanned** | ✓ Trivy | ✗ manual | ✗ manual | ✗ manual |



**Why DebugBox wins:**
- ✅ **Smaller when you need it** (14.36 MB vs 201.67 MB)
- ✅ **Larger when you need it** (104.45 MB for SRE workflows)
- ✅ **Kubernetes-first design** (kubectx/kubens built-in)
- ✅ **Predictable** (pinned tools, repeatable builds)



**When to use alternatives:**
- **busybox**: Ultra-minimal, don't need debugging tools
- **netshoot**: Need everything in one image, bandwidth isn't a concern
- **Alpine**: Need a base image, not a debugging toolkit
- **DebugBox**: Want the right tool for the right size



---



## What DebugBox Is Perfect For



- ✅ **Ephemeral debugging containers** (`kubectl debug`)
- ✅ **One-off troubleshooting sessions**
- ✅ **Resource-constrained environments** (edge, IoT, restricted bandwidth)
- ✅ **Multi-cluster operations** (kubectx/kubens included)
- ✅ **Incident response** (fast pull, ready to go)
- ✅ **Learning Kubernetes networking**
- ✅ **SRE forensics workflows** (power variant)



---



## What DebugBox Is NOT



- ❌ **Not a persistent sidecar** — use for ephemeral containers only
- ❌ **Not a production workload** — runs as root, for debugging only
- ❌ **Not a Kubernetes control plane tool** — no kubectl, no kube-proxy config
- ❌ **Not a security scanner** — use Trivy or similar for vulnerability scanning



**Use it for ephemeral debugging only.**



---



## Usage



### Kubernetes



```bash
# Attach to running pod
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox

# Create standalone session
kubectl run debug --rm -it --image=ghcr.io/ibtisam-iq/debugbox --restart=Never

# Use a specific variant
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox-lite
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox-power
```



### Docker



```bash
# Interactive session
docker run -it ghcr.io/ibtisam-iq/debugbox:latest

# Run a command
docker run ghcr.io/ibtisam-iq/debugbox-lite curl https://example.com

# Mount local filesystem
docker run -it -v /path/to/local:/mnt ghcr.io/ibtisam-iq/debugbox
```



---



## Image Tags & Registries



- **Primary**: GHCR (`ghcr.io/ibtisam-iq/debugbox*`)
- **Mirror**: Docker Hub (`mibtisam/debugbox*`)



**Tagging**:
- Semantic versions: `v1.0.0`, `v1.0.1`
- `:latest` → newest stable
- Unqualified name → **balanced** variant



**Best practice**:
- Interactive: `:latest`
- Production/CI: pinned `vX.Y.Z`



---



## Documentation



**Full docs:** [https://debugbox.ibtisam-iq.com](https://debugbox.ibtisam-iq.com)


**Getting Started:**
- **[Variants Overview](https://debugbox.ibtisam-iq.com/latest/variants/overview/)** — detailed tool lists by variant
- **[Tooling Manifest](https://debugbox.ibtisam-iq.com/latest/reference/manifest/)** — complete feature documentation


**Usage Guides:**
- **[Kubernetes Usage](https://debugbox.ibtisam-iq.com/latest/usage/kubernetes/)** — kubectl debug examples
- **[Docker Usage](https://debugbox.ibtisam-iq.com/latest/usage/docker/)** — Docker run examples
- **[Common Workflows](https://debugbox.ibtisam-iq.com/latest/guides/examples/)** — real debugging scenarios


**Development & Security:**
- **[Local Development](https://debugbox.ibtisam-iq.com/latest/development/local-setup/)** — build and test locally
- **[Contributing Guidelines](CONTRIBUTING.md)** — how to contribute
- **[Security Policy](SECURITY.md)** — report security issues



---



## Local Development



```bash
git clone https://github.com/ibtisam-iq/debugbox.git
cd debugbox



make build-all     # All variants
make test-all      # Smoke tests
make scan          # Trivy scan
```



---



## Security



DebugBox takes security seriously:



- 🔒 **Trivy scanning** — HIGH/CRITICAL vulnerabilities block release
- 🔒 **Pinned tool versions** — deterministic builds, no floating tags
- 🔒 **Alpine Linux base** — minimal attack surface (~3.9 MB base)
- 🔒 **No unnecessary packages** — each variant includes only what it promises



**Known Vulnerabilities:**  
We maintain transparency about known ignored vulnerabilities in optional utilities. See **[SECURITY.md](SECURITY.md)** for full details on CVE suppression rationale and risk assessment.



**Report security issues privately** **[SECURITY.md](SECURITY.md)**



---



## Contributing



Found a bug? Have an idea? We welcome contributions!



→ **[Contributing Guidelines](CONTRIBUTING.md)**



---



## License



[MIT License](LICENSE) — Free to use, modify, and distribute.



---



## FAQ



**Q: Can I use DebugBox in production?**  
A: No. DebugBox runs as root and is designed for ephemeral debugging containers only. Use `kubectl debug` or temporary pods.



**Q: Why not just use netshoot?**  
A: netshoot is great! But it's 201.67 MB. On resource-constrained clusters, DebugBox lite (14.36 MB) pulls 14× faster. Choose the right tool for your environment.



**Q: What if I need a tool not in DebugBox?**  
A: You can extend DebugBox by creating your own Dockerfile. See **[Local Development](https://debugbox.ibtisam-iq.com/latest/development/local-setup/)**.



**Q: Does DebugBox work on Kubernetes 1.18+?**  
A: Yes. Works on Kubernetes 1.18+. Requires `kubectl debug` support (1.20+ for best experience).



**Q: Can I use DebugBox outside Kubernetes?**  
A: Absolutely! `docker run -it ghcr.io/ibtisam-iq/debugbox` works perfectly for local debugging.



**Q: What's the difference between balanced and power?**  
A: **Balanced** is the daily driver with kubectl helpers and networking. **Power** adds deep routing tools (iptables, nftables, bird), packet analysis (tshark), and Python scripting for SRE workflows.



**Q: What shell does each variant use?**  
A: **Lite** uses ash (busybox shell). **Balanced & Power** use bash with full bash-completion support.



**More questions?** → **[Full FAQ](https://debugbox.ibtisam-iq.com/latest/guides/troubleshooting/)**



---



## Changelog



**v1.0.0** (Jan 2026)
- Public release
- 3 variants: lite, balanced, power
- Multi-arch support (amd64, arm64)
- Kubernetes-optimized with kubectx/kubens
- SRE-grade routing and analysis tools in power variant



→ **[Full changelog](CHANGELOG.md)**



---



## Support & Community



- 💬 **GitHub Discussions** — ask questions, share ideas
- 🐛 **GitHub Issues** — report bugs or request features
- 📖 **Documentation** — **https://debugbox.ibtisam-iq.com**
- 🤝 **Contributor Covenant** — **[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)**



---



**Built with ❤️ for Kubernetes debugging by [@ibtisam-iq](https://github.com/ibtisam-iq)**



**Faster pulls. Faster debugging. Right-sized containers.**
