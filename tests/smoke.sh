#!/bin/sh
set -eu

# ------------------------------------------------------------
# DebugBox Smoke Test (infra-bootstrap enhanced)
# ------------------------------------------------------------

LIB_URL="https://raw.githubusercontent.com/ibtisam-iq/infra-bootstrap/main/scripts/lib/common.sh"
LIB_PATH="/tmp/infra-bootstrap-common.sh"
LIB_SHA256="__PUT_REAL_SHA256_HERE__"
LIB_LOADED=false

cleanup() {
    [ -f "$LIB_PATH" ] && rm -f "$LIB_PATH"
}
trap cleanup EXIT

if command -v curl >/dev/null 2>&1; then
    if curl -fsSL \
        --connect-timeout 3 \
        --max-time 10 \
        --retry 2 \
        --retry-delay 1 \
        "$LIB_URL" -o "$LIB_PATH"; then

        if [ -n "$LIB_SHA256" ]; then
            echo "${LIB_SHA256}  ${LIB_PATH}" | sha256sum -c - >/dev/null 2>&1 || {
                echo "[WARN] infra-bootstrap checksum verification failed"
                LIB_LOADED=false
            }
        fi

        # shellcheck disable=SC1090
        . "$LIB_PATH"
        LIB_LOADED=true
    fi
fi

# Fallbacks ONLY if library not loaded
if [ "$LIB_LOADED" != "true" ]; then
    banner() { echo "==> $*"; }
    info()   { echo "[INFO] $*"; }
    ok()     { echo "[ OK ] $*"; }
    error()  { echo "[ERROR] $*"; exit 1; }
fi

# ------------------------------------------------------------
banner "infra-bootstrap – DebugBox smoke test started"

info "User identity"
USER_NAME="$(whoami)"
USER_UID="$(id -u)"
USER_GID="$(id -g)"
ok "user=${USER_NAME} uid=${USER_UID} gid=${USER_GID}"
blank

info "Core tools"
command -v curl >/dev/null || error "curl missing"
command -v jq   >/dev/null || error "jq missing"
command -v yq   >/dev/null || error "yq missing"
ok "Core tools found"
blank

info "Tool versions"
ok "curl: $(curl --version | awk 'NR==1 {print $2}')"
ok "jq:   $(jq --version | sed 's/^jq-//')"
ok "yq:   $(yq --version)"
blank

info "Networking"
command -v ip >/dev/null || error "ip missing"
ip addr >/dev/null || error "ip addr failed"
ok "Networking check passed"
blank

info "DNS resolution"
if command -v nslookup >/dev/null 2>&1; then
    nslookup google.com >/dev/null
elif command -v dig >/dev/null 2>&1; then
    dig google.com >/dev/null
else
    error "No DNS lookup tool found"
fi
ok "DNS resolution passed"
blank

info "Filesystem"
test -w /tmp || error "/tmp not writable"
touch /tmp/smoke-test || error "tmp write failed"
rm /tmp/smoke-test
ok "Filesystem check passed"
blank

banner "infra-bootstrap – DebugBox smoke test PASSED"
