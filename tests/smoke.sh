#!/usr/bin/env bash
set -euo pipefail


# Basic smoke tests run inside container
# Usage: docker run --rm -it ghcr.io/ibtsam-iq/debugbox:balanced-<tag> /tests/smoke.sh


which yq >/dev/null && yq --version
which jq >/dev/null && jq --version
which curl >/dev/null && curl --version
ip a >/dev/null
if command -v nslookup >/dev/null 2>&1; then
    nslookup google.com >/dev/null
    elif command -v dig >/dev/null 2>&1; then
    dig google.com >/dev/null
    else
    echo "No DNS lookup tool found"
    exit 1
    fi