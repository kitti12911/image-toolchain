FROM golang:1.26.2-alpine@sha256:f85330846cde1e57ca9ec309382da3b8e6ae3ab943d2739500e08c86393a21b1

LABEL org.opencontainers.image.source="https://github.com/kitti12911/image-toolchain"
LABEL org.opencontainers.image.description="Go, protobuf, Buf, and custom generator CI toolchain"

RUN apk add --no-cache \
	ca-certificates \
	git \
	make \
	protobuf

RUN --mount=type=cache,target=/go/pkg/mod \
	--mount=type=cache,target=/root/.cache/go-build \
	go install github.com/bufbuild/buf/cmd/buf@v1.69.0 \
	&& go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.11 \
	&& go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.6.1 \
	&& go install github.com/kitti12911/lib-orm/v2/cmd/fieldmapgen@v2.5.0 \
	&& go install github.com/kitti12911/lib-orm/v2/cmd/patchfieldgen@v2.5.0

WORKDIR /workspace
