FROM golang:1.26.3-alpine@sha256:91eda9776261207ea25fd06b5b7fed8d397dd2c0a283e77f2ab6e91bfa71079d

LABEL org.opencontainers.image.source="https://github.com/kitti12911/image-toolchain"
LABEL org.opencontainers.image.description="Go, protobuf, Buf, OpenAPI, and custom generator CI toolchain"

RUN apk add --no-cache \
	ca-certificates \
	git \
	make \
	protobuf

RUN --mount=type=secret,id=go_gitconfig,target=/root/.gitconfig,required=false \
	--mount=type=cache,target=/go/pkg/mod \
	--mount=type=cache,target=/root/.cache/go-build \
	export GOPRIVATE='github.com/kitti12911/*' \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/bufbuild/buf/cmd/buf@v1.69.0 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.12.2 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/oasdiff/oasdiff@v1.15.3 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.11 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.6.2 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/kitti12911/lib-orm/v3/cmd/fieldmapgen@v3.3.0 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/kitti12911/lib-orm/v3/cmd/patchfieldgen@v3.3.0 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/kitti12911/lib-orm/v3/cmd/protomapgen@v3.3.0

WORKDIR /workspace
