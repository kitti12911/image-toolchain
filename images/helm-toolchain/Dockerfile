# syntax=docker/dockerfile:1.7
FROM golang:1.26.4-alpine@sha256:3ad57304ad93bbec8548a0437ad9e06a455660655d9af011d58b993f6f615648

LABEL org.opencontainers.image.source="https://github.com/kitti12911/image-toolchain"
LABEL org.opencontainers.image.description="Helm CI toolchain"

RUN apk upgrade --no-cache libcrypto3 libssl3 \
	&& apk add --no-cache \
	ca-certificates \
	make

RUN --mount=type=cache,target=/go/pkg/mod \
	--mount=type=cache,target=/root/.cache/go-build \
	mkdir /tmp/helm-build \
	&& cd /tmp/helm-build \
	&& go mod init helm-toolchain-build \
	&& go get helm.sh/helm/v3/cmd/helm@v3.21.2 google.golang.org/grpc@v1.80.0 github.com/containerd/containerd@v1.7.32 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" helm.sh/helm/v3/cmd/helm

WORKDIR /workspace
