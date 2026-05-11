.PHONY: build build-image-toolchain build-release build-security check check-image-toolchain check-release check-security pretty markdownlint

IMAGE_TOOLCHAIN ?= image-toolchain:local
RELEASE_TOOLCHAIN ?= release-toolchain:local
SECURITY_TOOLCHAIN ?= security-toolchain:local

build: build-image-toolchain build-release build-security

build-image-toolchain:
	docker buildx build --load -t $(IMAGE_TOOLCHAIN) images/image-toolchain

build-release:
	docker buildx build --load -t $(RELEASE_TOOLCHAIN) images/release-toolchain

build-security:
	docker buildx build --load -t $(SECURITY_TOOLCHAIN) images/security-toolchain

check: check-image-toolchain check-release check-security

check-image-toolchain: build-image-toolchain
	./scripts/check-tools.sh $(IMAGE_TOOLCHAIN) image

check-release: build-release
	./scripts/check-tools.sh $(RELEASE_TOOLCHAIN) release

check-security: build-security
	./scripts/check-tools.sh $(SECURITY_TOOLCHAIN) security

pretty:
	prettier --write "**/*.{md,markdown,yml,yaml,json,jsonc}"
