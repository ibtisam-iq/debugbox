# Image Sizes

Actual compressed sizes measured from builds.

## Size Comparison

### Compressed Sizes (What You Download)

| Variant | amd64 | arm64 |
|---------|-------|-------|
| lite | 15 MB | 15 MB |
| balanced | 48 MB | 48 MB |
| power | 110 MB | 103 MB |

### Uncompressed Sizes (Runtime Disk Usage)

| Variant | Approximate |
|---------|-------------|
| lite | ~50 MB |
| balanced | ~150 MB |
| power | ~350 MB |

---

## Comparison to Alternatives

```
netshoot:         208 MB  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 100%
DebugBox power:   110 MB  ━━━━━━━━━━━━━━━━━━━━━━ 53%
DebugBox balanced: 48 MB  ━━━━━━━━━ 23%
DebugBox lite:     15 MB  ━━ 7%
busybox:           1.5 MB  ░ <1%
```

### Analysis

- **DebugBox lite** is 93% smaller than netshoot
- **DebugBox balanced** is 77% smaller than netshoot
- **DebugBox power** is 47% smaller than netshoot

For 90% of debugging tasks, you'll use balanced, which saves 160 MB per pull compared to netshoot.

---

## Pull Time Impact

Estimated download times (1 Mbps connection):

| Image | Size | Time |
|-------|------|------|
| lite | 15 MB | ~2 seconds |
| balanced | 48 MB | ~6 seconds |
| power | 110 MB | ~14 seconds |
| netshoot | 208 MB | ~27 seconds |

In production incidents, 15-20 seconds can matter.

---

## Disk Space Savings

In a cluster pulling all variants multiple times:

```
Single netshoot pull:        208 MB
Three DebugBox variants:    173 MB (15+48+110)

Savings per pull:           35 MB
Savings over 100 pulls:    3.5 GB
```

---

## Measurement Details

Sizes measured with:
```bash
{% raw %}
docker images --format "table {{.Repository}}\t{{.Size}}"
{% endraw %}
```

Variants built for both `linux/amd64` and `linux/arm64` with identical tooling and minimal differences.

---

## Why the Size Difference?

- **lite:** Minimal networking tools, BusyBox shell
- **balanced:** Adds bash, editors, system tools (most use cases)
- **power:** Adds forensics (tshark, ltrace), routing (iptables, nftables), Python
- **netshoot:** Single image with everything

DebugBox philosophy: **Use what you need, not everything at once.**
