# Power Variant

**~110 MB** — Full SRE-grade forensics toolkit.

The **power** variant includes everything from balanced, plus advanced tools for deep investigation.

## When to Use Power

Use only when you need:

- Detailed packet analysis (`tshark`)
- Library-level tracing (`ltrace`)
- Firewall/routing debugging (`nftables`, `bird`, `conntrack-tools`)
- Custom Python scripting (`pip3`)
- High-precision network testing

**Do not use power** for routine tasks — stick with balanced to save time and bandwidth.

## Key Additions Over Balanced

| Category            | Tools Added                                      |
|---------------------|--------------------------------------------------|
| Packet Analysis     | `tshark`                                         |
| Advanced Network    | `fping`, `speedtest-cli`, `nmap-nping`, `nmap-scripts` |
| System Internals    | `ltrace`                                         |
| Routing & Firewall  | `iptables`, `nftables`, `conntrack-tools`, `bird`, `bridge-utils` |
| Scripting           | Python 3 + `pip3`                                |
| Editors             | `nano` (in addition to `vim`)                    |
| YAML Processing     | Pinned `yq` v4.x binary (SHA-verified)           |

→ Full details: **[Tooling Manifest](../reference/manifest.md)**

## Example Usage

```bash
kubectl run debug-power --rm -it \
  --image=ghcr.io/ibtisam-iq/debugbox-power \
  --restart=Never
```

Inside:
```bash
tshark -i eth0 -f "port 443"
nft list ruleset
conntrack -L
ltrace -p 1234
pip3 install requests
python3 -c "import requests; print(requests.get('https://api.ipify.org').text)"
```

## Image Details

- Compressed size: ~110 MB
- Architectures: `linux/amd64`, `linux/arm64`

Pull:
```bash
ghcr.io/ibtisam-iq/debugbox-power:latest
```

## Navigation

← **[Balanced Variant](balanced.md)** | **[Variants Overview](overview.md)** →
