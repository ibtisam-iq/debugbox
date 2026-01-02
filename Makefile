# ============================================================
# DebugBox Makefile
# Author: Muhammad Ibtisam
# Purpose: OSS-grade build, test, lint, scan, release
# ============================================================

# -------------------------------
# Load environment
# -------------------------------
ifneq (,$(wildcard .env))
	include .env
	export
endif

# -------------------------------
# Project metadata
# -------------------------------
IMAGE_NAME        ?= debugbox
VARIANTS          := lite balanced power
DOCKERFILES_DIR   := dockerfiles
TESTS_DIR         := tests

# Versioning (OSS-safe)
VERSION ?= $(shell git describe --tags --dirty --always 2>/dev/null || echo dev)
LOCAL_TAG ?= local

# Registry
REGISTRY_GHCR ?= ghcr.io/ibtisam-iq/$(IMAGE_NAME)

# Build configuration
PLATFORM  ?= linux/amd64,linux/arm64
NO_CACHE  ?= false

# Tooling
HADOLINT        ?= hadolint
HADOLINT_IMAGE  ?= hadolint/hadolint:latest
TRIVY           ?= trivy

# Docker
DOCKER_BUILD := docker buildx build

# -------------------------------
# Help
# -------------------------------
.PHONY: help
help:
	@echo ""
	@echo "DebugBox — Open Source Makefile"
	@echo ""
	@echo "Build:"
	@echo "  make build-<variant>     Build image (lite | balanced | power)"
	@echo "  make build-all           Build all variants"
	@echo ""
	@echo "Test:"
	@echo "  make test-<variant>      Run smoke tests"
	@echo "  make test-all            Test all variants"
	@echo ""
	@echo "Quality:"
	@echo "  make lint                Lint Dockerfiles (hadolint)"
	@echo "  make scan                Scan images (trivy)"
	@echo ""
	@echo "Release:"
	@echo "  make push-<variant>      Push image to GHCR"
	@echo "  make push-all            Push all variants"
	@echo "  make release             Tag + push (maintainers only)"
	@echo ""
	@echo "Args:"
	@echo "  PLATFORM=linux/arm64     Override platforms"
	@echo "  NO_CACHE=true            Disable build cache"
	@echo ""

# -------------------------------
# Internal helpers
# -------------------------------
define docker_build
	@echo "==> Building $(IMAGE_NAME):$1-$(LOCAL_TAG)"
	$(DOCKER_BUILD) \
		--platform $(PLATFORM) \
		$(if $(filter true,$(NO_CACHE)),--no-cache,) \
		--load \
		-f $(DOCKERFILES_DIR)/Dockerfile.$1 \
		-t $(IMAGE_NAME):$1-$(LOCAL_TAG) \
		.
endef

define docker_test
	@echo "==> Testing $(IMAGE_NAME):$1-$(LOCAL_TAG)"
	docker run --rm -t \
		-v $(PWD)/$(TESTS_DIR):/tests \
		$(IMAGE_NAME):$1-$(LOCAL_TAG) \
		/bin/sh -c "\
			if [ -f /tests/smoke.sh ]; then \
				sh /tests/smoke.sh; \
			else \
				echo 'No smoke tests found'; \
			fi"
endef

define docker_push
	@echo "==> Pushing $(REGISTRY_GHCR):$1-$(VERSION)"
	docker tag \
		$(IMAGE_NAME):$1-$(LOCAL_TAG) \
		$(REGISTRY_GHCR):$1-$(VERSION)
	docker push $(REGISTRY_GHCR):$1-$(VERSION)
endef

# -------------------------------
# Lint
# -------------------------------
.PHONY: lint
lint:
	@echo "==> Linting Dockerfiles"
	@if command -v $(HADOLINT) >/dev/null 2>&1; then \
		echo "Using local hadolint"; \
		for f in $(VARIANTS); do \
			$(HADOLINT) $(DOCKERFILES_DIR)/Dockerfile.$$f || exit 1; \
		done; \
	else \
		echo "Using containerized hadolint"; \
		for f in $(VARIANTS); do \
			docker run --rm -i \
				-v $(PWD):/work \
				-w /work \
				$(HADOLINT_IMAGE) \
				$(DOCKERFILES_DIR)/Dockerfile.$$f || exit 1; \
		done; \
	fi
	@echo "Dockerfile lint passed"

# -------------------------------
# Build
# -------------------------------
.PHONY: build-%
build-%:
	$(call docker_build,$*)

.PHONY: build-all
build-all: lint
	@for v in $(VARIANTS); do \
		$(MAKE) build-$$v || exit 1; \
	done

# -------------------------------
# Test
# -------------------------------
.PHONY: test-%
test-%:
	$(call docker_test,$*)

.PHONY: test-all
test-all: build-all
	@for v in $(VARIANTS); do \
		$(MAKE) test-$$v || exit 1; \
	done

# -------------------------------
# Security scan
# -------------------------------
.PHONY: scan
scan: build-all
	@echo "==> Scanning images with Trivy"
	@for v in $(VARIANTS); do \
		$(TRIVY) image \
			--severity HIGH,CRITICAL \
			--exit-code 1 \
			$(IMAGE_NAME):$$v-$(LOCAL_TAG) || exit 1; \
	done
	@echo "All scans clean"

# -------------------------------
# Push
# -------------------------------
.PHONY: push-%
push-%:
	$(call docker_push,$*)

.PHONY: push-all
push-all: build-all test-all scan
	@for v in $(VARIANTS); do \
		$(MAKE) push-$$v || exit 1; \
	done

# -------------------------------
# Release (maintainers only)
# -------------------------------
.PHONY: release
release: push-all
	@echo "==> Releasing $(VERSION)"
	@git tag $(VERSION)
	@git push origin $(VERSION)

# -------------------------------
# Cleanup
# -------------------------------
.PHONY: clean
clean:
	@echo "==> Cleaning local images"
	@for v in $(VARIANTS); do \
		docker rmi -f $(IMAGE_NAME):$$v-$(LOCAL_TAG) >/dev/null 2>&1 || true; \
		docker rmi -f $(IMAGE_NAME):$$v-scan       >/dev/null 2>&1 || true; \
	done
	@docker image prune -f >/dev/null
	@echo "Cleanup complete"
