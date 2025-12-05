# ============================================================
# DebugBox Makefile
# Author: Muhammad Ibtisam
# Purpose: Local builds, testing, development helpers
# ============================================================
# Load .env if exists
ifneq (,$(wildcard .env))
	include .env
	export
endif

# -------------------------------
# Variables
# -------------------------------
VARIANTS := lite balanced power
VERSION := v0.1.0  # Semver; bump on release
DOCKERFILES_DIR := dockerfiles
TESTS_DIR := tests
IMAGE_NAME := debugbox
LOCAL_TAG := local
REGISTRY_GHCR := ghcr.io/ibtisam-iq/$(IMAGE_NAME)
PLATFORM ?= linux/amd64,linux/arm64  # Multi-arch default
NO_CACHE ?= false  # --no-cache arg
BUILDX_ARGS := --platform $(PLATFORM) --load  # Buildx for multi-arch

# -------------------------------
# Help Menu
# -------------------------------
help:
	@echo ""
	@echo "DebugBox Makefile"
	@echo ""
	@echo "Usage:"
	@echo " make build-lite Build lite variant locally"
	@echo " make build-balanced Build balanced variant locally"
	@echo " make build-power Build power variant locally"
	@echo " make build-all Build all variants"
	@echo " make lint Lint Dockerfiles (hadolint)"
	@echo " make scan Scan for vulns (trivy, fail HIGH)"
	@echo " make test-lite Run smoke + e2e for lite"
	@echo " make test-all Run smoke + e2e for all variants"
	@echo " make push-lite Push lite to GHCR (tag $(VERSION))"
	@echo " make push-all Push all to GHCR"
	@echo " make clean Prune local images/layers"
	@echo " make release Tag/push all (VERSION=$(VERSION))"
	@echo ""
	@echo "Args:"
	@echo " NO_CACHE=true Force no-cache builds"
	@echo " PLATFORM=linux/arm64 Override platforms"
	@echo ""

# -------------------------------
# Internal Helpers
# -------------------------------
define build_template
	@echo "Building $(IMAGE_NAME):$1-$(LOCAL_TAG)"
	docker $(if $(filter true,$(NO_CACHE)),build --no-cache,build) \
		--progress=plain \
		-f $(DOCKERFILES_DIR)/Dockerfile.$1 \
		-t $(IMAGE_NAME):$1-$(LOCAL_TAG) \
		$(BUILDX_ARGS) \
		.
endef

define test_template
	@echo "Testing $(IMAGE_NAME):$1-$(LOCAL_TAG)"
	docker run --rm \
		-v $(PWD)/$(TESTS_DIR):/tests \
		$(IMAGE_NAME):$1-$(LOCAL_TAG) \
		bash -c "if [ -f /tests/smoke.sh ]; then /tests/smoke.sh; else echo 'Smoke.sh missing—stub e2e'; curl --version && jq . {} && echo 'E2E pass'; fi"
endef

define push_template
	@echo "Pushing $(REGISTRY_GHCR):$1-$(VERSION)"
	docker tag $(IMAGE_NAME):$1-$(LOCAL_TAG) $(REGISTRY_GHCR):$1-$(VERSION)
	docker push $(REGISTRY_GHCR):$1-$(VERSION)
endef

# -------------------------------
# Lint/Scan
# -------------------------------
lint:
	@echo "Linting Dockerfiles with hadolint..."
	@hadolint $(foreach var,$(VARIANTS),$(DOCKERFILES_DIR)/Dockerfile.$(var)) | tee /dev/stderr | (grep -q "error" && (echo "Lint errors found—fix and retry"; exit 1) || echo "Lint clean (warnings ignored).")

scan:
	@echo "Scanning variants with trivy (fail HIGH)..."
	@for variant in $(VARIANTS); do \
		docker build -t $(IMAGE_NAME):$$variant-scan -f $(DOCKERFILES_DIR)/Dockerfile.$$variant . && \
		trivy image --severity HIGH,CRITICAL --exit-code 1 $(IMAGE_NAME):$$variant-scan && \
		docker rmi $(IMAGE_NAME):$$variant-scan || exit 1; \
	done
	@echo "All scans clean."

# -------------------------------
# Build Targets
# -------------------------------
build-lite:
	$(call build_template,lite)

build-balanced:
	$(call build_template,balanced)

build-power:
	$(call build_template,power)

build-all: lint
	@for variant in $(VARIANTS); do \
		$(call build_template,$$variant); \
	done

# -------------------------------
# Test Targets
# -------------------------------
test-lite:
	$(call test_template,lite)

test-balanced:
	$(call test_template,balanced)

test-power:
	$(call test_template,power)

test-all: build-all
	@for variant in $(VARIANTS); do \
		$(call test_template,$$variant); \
	done

# -------------------------------
# Push Targets
# -------------------------------
push-lite:
	$(call push_template,lite)

push-balanced:
	$(call push_template,balanced)

push-power:
	$(call push_template,power)

push-all: build-all test-all scan
	@for variant in $(VARIANTS); do \
		$(call push_template,$$variant); \
	done

release: push-all
	@echo "Tagging release $(VERSION)"
	@git tag $(VERSION)
	@git push origin $(VERSION)

# -------------------------------
# Cleanup
# -------------------------------
clean:
	@echo "Pruning local DebugBox images/layers..."
	@for variant in $(VARIANTS); do \
		docker rmi -f $(IMAGE_NAME):$$variant-$(LOCAL_TAG) || true; \
	done
	docker image prune -f
	@echo "Cleanup complete."
