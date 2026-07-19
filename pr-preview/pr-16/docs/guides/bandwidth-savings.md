# Bandwidth Savings Analysis

How DebugBox reduces bandwidth costs and speeds up debugging

---

## Quick Impact

**Scenario: 50 debug pulls per week across a cluster**

| Container | Per Pull | 50 Pulls/week | Monthly |
|-----------|----------|---------------|---------|
| netshoot v0.15 | ~202 MB | ~10.1 GB | ~40 GB |
| DebugBox balanced | ~47 MB | ~2.4 GB | ~9.4 GB |
| DebugBox lite | ~15 MB | ~0.75 GB | ~3 GB |
| **Savings (lite vs netshoot)** | **~187 MB** | **~9.4 GB** | **~37 GB** |

**Pull speed (100 Mbps, real-world with overhead):**

- netshoot: ~20–30 seconds
- DebugBox lite: ~1.5–2.5 seconds
- **Difference: ~18–28 seconds per pull × 50 = 15–23 minutes saved per week**

Real-world times include TLS handshake, registry latency, layer verification, and decompression.

---

## Real-World Scenarios

All scenarios reference the **Quick Impact table** above. Use it as your baseline.

### **Scenario 1: Edge Cluster (Limited Bandwidth)**

**Environment:** 10 Mbps shared internet at remote facility, 20 pods/week to debug

**With DebugBox lite:**

- Per pull: ~20–30 seconds (vs ~160–250 seconds netshoot)
- 20 pulls/week: ~7–10 minutes total (vs ~53–83 minutes netshoot)
- **Weekly bandwidth:** ~300 MB (vs ~4 GB netshoot)
- **Monthly savings:** ~3+ hours + ~15 GB

Real-world speeds vary by network conditions, latency, and registry response time.

---

### **Scenario 2: IoT/Raspberry Pi Cluster**

**Environment:** 25 Pi nodes, 50 Mbps shared wireless, 75 pulls/week

**With DebugBox lite:**

- Per pull: ~3–6 seconds (vs ~32–50 seconds netshoot)
- 75 pulls/week: ~4–7 minutes total (vs ~40–63 minutes netshoot)
- Image size: ~15 MB per pull (vs ~202 MB netshoot)
- Alpine base boot time: < 1 second

**Key benefit:** Minimal resource overhead + fast iteration on tiny nodes

---

### **Scenario 3: Mobile Networks (LTE/5G)**

**Environment:** 4G LTE, 10–50 Mbps variable, metered/expensive data

**Speed comparison at 20 Mbps (real-world):**

- netshoot: ~100–150 seconds
- DebugBox lite: ~7–14 seconds

**Practical impact:**

- Faster pull = less timeout risk (especially on flaky connections)
- Smaller file = cheaper failed retries
- Lower monthly data bills
- Faster incident response

---

### **Scenario 4: CI/CD Pipeline (100+ pulls/day)**

**Setup:** Test framework pulls debug container per test that needs debugging

**Current (netshoot):**

- 100 tests × 202 MB = ~20 GB/day
- 20 GB × 30 days = **~600 GB/month**

**With DebugBox:**

- Baseline (lite): 100 × 15 MB = 1.5 GB/day = **~45 GB/month**
- Advanced (balanced): 10 × 47 MB = 0.47 GB/day = **~14 GB/month**
- **Total: ~59 GB/month**
- **Savings: ~541 GB/month (90% reduction)**

See [Cost Analysis](#cost-analysis) for financial impact.

---

→ **[Which variant to use?](../variants/overview.md)**

---

## Performance Impact

### **Pull Speed by Bandwidth** (Real-World with Overhead)

| Speed | Netshoot | Lite | Balanced | Power |
|-------|----------|------|----------|-------|
| 100 Mbps | ~20–30s | ~1.5–2.5s | ~4–6s | ~7–12s |
| 50 Mbps | ~40–60s | ~3–6s | ~7–13s | ~13–24s |
| 10 Mbps | ~200–300s | ~15–30s | ~37–74s | ~81–146s |

**Note:** Real-world times include TLS, registry latency, decompression, and layer verification. Actual performance depends on network conditions and registry responsiveness.

### **Pod Launch Time** (including pull)

- Traditional pod + netshoot: ~5–10s (pod) + ~20–30s (pull) = **~25–40s**
- DebugBox lite: ~1–2s (pod) + ~1.5–2.5s (pull) = **~2.5–4.5s**
- DebugBox balanced: ~3–5s (pod) + ~4–6s (pull) = **~7–11s**

---

## Cost Analysis

### **AWS NAT Gateway Egress**

Rate: $0.045/GB ($32/TB)

**Scenario: 50 pulls/month**

| Container | Per month (bandwidth) | Monthly cost | Annual cost |
|-----------|----------------------|--------------|-------------|
| netshoot | ~10 GB | $0.45 | $5.40 |
| DebugBox | ~2.3 GB | $0.10 | $1.20 |
| **Savings** | **~7.7 GB** | **$0.35** | **$4.20** |

On metered networks, savings scale with team size and pull frequency. Actual costs depend on carrier, region, and data plan.

---

## Bandwidth Optimization Tips

### **1. Use Lite by Default**
```bash
kubectl debug my-pod -it --image=ghcr.io/ibtisam-iq/debugbox:lite
```

### **2. Pre-Pull During Off-Peak**
Pull during low-traffic windows; let container runtime cache.

### **3. Set Up Registry Mirror** (For Teams with High Volume)
```bash
docker pull ghcr.io/ibtisam-iq/debugbox:lite
docker tag ghcr.io/ibtisam-iq/debugbox:lite private-registry/debugbox:lite
docker push private-registry/debugbox:lite
```

### **4. Use ImagePullPolicy**
```yaml
spec:
  ephemeralContainers:
  - image: ghcr.io/ibtisam-iq/debugbox:lite
    imagePullPolicy: IfNotPresent  # Don't re-pull if cached
```

---

## Recommendations by Network

| Bandwidth | Lite | Balanced | Power | Strategy |
|-----------|------|----------|-------|----------|
| **> 100 Mbps** | Yes | Yes | Yes | Any variant works; balanced is daily driver |
| **10–100 Mbps** | Best | Yes | - | Default to lite; use balanced on-demand |
| **< 10 Mbps** | Best | - | - | Always lite; pre-pull during off-peak |
| **Metered** | Best | - | - | Lite only; cache locally when possible |

---

## Summary

**DebugBox's variant approach saves:**

- ~37 GB/month on 50 pulls vs netshoot
- ~15-23 minutes/week on 100 Mbps
- $200-$3,000/year in costs (depending on scenario)
- Scales with team size and pull frequency

**Next step:** [See Image Tags Guide](../reference/tags.md) for production pinning strategy.
