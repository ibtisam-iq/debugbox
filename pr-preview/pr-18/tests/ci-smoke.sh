#!/bin/sh
set -eu

# ============================================================
# DebugBox CI Smoke Test
#
# Purpose:
# - Validate runtime behavior of the container
# - NO external network access
# - NO dynamic downloads
# - Deterministic & CI-safe
# ============================================================

echo "==> DebugBox CI smoke test started"

# ------------------------------------------------------------
# Identity & shell
# ------------------------------------------------------------
whoami >/dev/null
id >/dev/null
echo "[OK] User identity verified"

# ------------------------------------------------------------
# Filesystem basics
# ------------------------------------------------------------
test -d /tmp
test -w /tmp
touch /tmp/ci-smoke-test
rm -f /tmp/ci-smoke-test
echo "[OK] Filesystem writable"

# ------------------------------------------------------------
# Process & procfs
# ------------------------------------------------------------
test -d /proc
ps >/dev/null
echo "[OK] Process subsystem working"

# ------------------------------------------------------------
# Networking stack (NO external access)
# ------------------------------------------------------------
command -v ip >/dev/null
ip link show >/dev/null
ip route show >/dev/null
echo "[OK] Networking stack present"

# ------------------------------------------------------------
# DNS configuration (no resolution)
# ------------------------------------------------------------
test -f /etc/resolv.conf
grep -q nameserver /etc/resolv.conf || true
echo "[OK] DNS configuration present"

# ------------------------------------------------------------
# Core tool availability (NO version checks)
# ------------------------------------------------------------
for bin in sh curl ip; do
    command -v "$bin" >/dev/null
done
echo "[OK] Core tools available"

# ------------------------------------------------------------
# Shell profile sanity (if present)
# ------------------------------------------------------------
if [ -d /etc/profile.d ]; then
    ls /etc/profile.d >/dev/null
fi
echo "[OK] Shell profile directory sane"

echo "==> DebugBox CI smoke test PASSED"
