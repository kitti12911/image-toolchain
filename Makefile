.PHONY: build build-image-toolchain check check-image-toolchain pretty markdownlint ci-markdownlint

IMAGE_TOOLCHAIN ?= image-toolchain:local

build: build-image-toolchain

build-image-toolchain:
	docker buildx build --load -t $(IMAGE_TOOLCHAIN) images/image-toolchain

check: check-image-toolchain

check-image-toolchain: build-image-toolchain
	./scripts/check-tools.sh $(IMAGE_TOOLCHAIN) image

pretty:
	prettier --write "**/*.{md,markdown,yml,yaml,json,jsonc}"

markdownlint:
	./scripts/ci/markdownlint.sh

ci-markdownlint:
	./scripts/ci/markdownlint.sh

# force update #3
