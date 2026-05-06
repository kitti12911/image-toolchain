.PHONY: build build-image-toolchain build-security check check-image-toolchain check-security pretty markdownlint

IMAGE_TOOLCHAIN ?= image-toolchain:local
SECURITY_TOOLCHAIN ?= security-toolchain:local

build: build-image-toolchain build-security

build-image-toolchain:
	docker buildx build --load -t $(IMAGE_TOOLCHAIN) images/image-toolchain

build-security:
	docker buildx build --load -t $(SECURITY_TOOLCHAIN) images/security-toolchain

check: check-image-toolchain check-security

check-image-toolchain: build-image-toolchain
	./scripts/check-tools.sh $(IMAGE_TOOLCHAIN) image

check-security: build-security
	./scripts/check-tools.sh $(SECURITY_TOOLCHAIN) security

pretty:
	prettier --write "**/*.{md,markdown,yml,yaml,json,jsonc}"
