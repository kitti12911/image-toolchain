FROM golang:1.26.3-alpine@sha256:91eda9776261207ea25fd06b5b7fed8d397dd2c0a283e77f2ab6e91bfa71079d

LABEL org.opencontainers.image.source="https://github.com/kitti12911/image-toolchain"
LABEL org.opencontainers.image.description="Helm CI toolchain"

RUN apk add --no-cache \
	ca-certificates \
	make

RUN --mount=type=cache,target=/go/pkg/mod \
	--mount=type=cache,target=/root/.cache/go-build \
	mkdir /tmp/helm-build \
	&& cd /tmp/helm-build \
	&& go mod init helm-toolchain-build \
	&& go get helm.sh/helm/v3/cmd/helm@v3.20.2 google.golang.org/grpc@v1.79.3 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" helm.sh/helm/v3/cmd/helm

WORKDIR /workspace
