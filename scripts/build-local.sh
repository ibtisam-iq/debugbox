#!/usr/bin/env bash
set -euo pipefail


# Local helper to build images reproducibly using buildx (requires Docker Buildx)
# Usage: ./scripts/build-local.sh balanced
VARIANT=${1:-balanced}
TAG_LOCAL=debugbox:${VARIANT}-local
DOCKERFILE="dockerfiles/Dockerfile.${VARIANT}"


docker build --progress=plain -f ${DOCKERFILE} -t ${TAG_LOCAL} .


echo "Built ${TAG_LOCAL}"