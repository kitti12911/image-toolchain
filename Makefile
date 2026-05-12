.PHONY: build build-image-toolchain build-migration build-release build-helm build-security build-supply-chain check check-image-toolchain check-migration check-release check-helm check-security check-supply-chain pretty markdownlint

IMAGE_TOOLCHAIN ?= image-toolchain:local
MIGRATION_TOOLCHAIN ?= migration-toolchain:local
RELEASE_TOOLCHAIN ?= release-toolchain:local
HELM_TOOLCHAIN ?= helm-toolchain:local
SECURITY_TOOLCHAIN ?= security-toolchain:local
SUPPLY_CHAIN_TOOLCHAIN ?= supply-chain-toolchain:local

build: build-image-toolchain build-migration build-release build-helm build-security build-supply-chain

build-image-toolchain:
	docker buildx build --load -t $(IMAGE_TOOLCHAIN) images/image-toolchain

build-migration:
	docker buildx build --load -t $(MIGRATION_TOOLCHAIN) images/migration-toolchain

build-release:
	docker buildx build --load -t $(RELEASE_TOOLCHAIN) images/release-toolchain

build-helm:
	docker buildx build --load -t $(HELM_TOOLCHAIN) images/helm-toolchain

build-security:
	docker buildx build --load -t $(SECURITY_TOOLCHAIN) images/security-toolchain

build-supply-chain:
	docker buildx build --load -t $(SUPPLY_CHAIN_TOOLCHAIN) images/supply-chain-toolchain

check: check-image-toolchain check-migration check-release check-helm check-security check-supply-chain

check-image-toolchain: build-image-toolchain
	./scripts/check-tools.sh $(IMAGE_TOOLCHAIN) image

check-migration: build-migration
	./scripts/check-tools.sh $(MIGRATION_TOOLCHAIN) migration

check-release: build-release
	./scripts/check-tools.sh $(RELEASE_TOOLCHAIN) release

check-helm: build-helm
	./scripts/check-tools.sh $(HELM_TOOLCHAIN) helm

check-security: build-security
	./scripts/check-tools.sh $(SECURITY_TOOLCHAIN) security

check-supply-chain: build-supply-chain
	./scripts/check-tools.sh $(SUPPLY_CHAIN_TOOLCHAIN) supply-chain

pretty:
	prettier --write "**/*.{md,markdown,yml,yaml,json,jsonc}"

# force update #3