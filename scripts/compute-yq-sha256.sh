#!/usr/bin/env bash
# Downloads yq and prints SHA256 so you can fill the build-arg or store in secrets
set -euo pipefail
VER=${1:-v4.44.3}
URL="https://github.com/mikefarah/yq/releases/download/${VER}/yq_linux_amd64"


curl -fsSL ${URL} -o /tmp/yq_bin
sha256sum /tmp/yq_bin | awk '{print $1}'
rm -f /tmp/yq_bin