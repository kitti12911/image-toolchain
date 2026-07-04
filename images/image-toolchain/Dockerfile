# syntax=docker/dockerfile:1.7
FROM golang:1.26.4-alpine@sha256:3ad57304ad93bbec8548a0437ad9e06a455660655d9af011d58b993f6f615648

LABEL org.opencontainers.image.source="https://github.com/kitti12911/image-toolchain"
LABEL org.opencontainers.image.description="Go, protobuf, Buf, OpenAPI, and custom generator CI toolchain"

RUN apk upgrade --no-cache libcrypto3 libssl3 \
	&& apk add --no-cache \
	ca-certificates \
	gcc \
	git \
	make \
	musl-dev \
	protobuf

RUN --mount=type=secret,id=go_gitconfig,target=/root/.gitconfig,required=false \
	--mount=type=cache,target=/go/pkg/mod \
	--mount=type=cache,target=/root/.cache/go-build \
	export GOPRIVATE='github.com/kitti12911/*' \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/bufbuild/buf/cmd/buf@v1.71.0 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.12.2 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/oasdiff/oasdiff@v1.21.0 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.11 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.6.2 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/kitti12911/lib-orm/v3/cmd/fieldmapgen@v3.3.0 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/kitti12911/lib-orm/v3/cmd/patchfieldgen@v3.3.0 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/kitti12911/lib-orm/v3/cmd/protomapgen@v3.3.0

WORKDIR /workspace
