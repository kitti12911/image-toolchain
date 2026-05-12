FROM golang:1.26.3-alpine@sha256:91eda9776261207ea25fd06b5b7fed8d397dd2c0a283e77f2ab6e91bfa71079d AS builder

ARG TRIVY_VERSION=0.70.0

RUN apk add --no-cache \
	ca-certificates \
	git

RUN --mount=type=cache,target=/go/pkg/mod \
	--mount=type=cache,target=/root/.cache/go-build \
	CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/zricethezav/gitleaks/v8@v8.30.1 \
	&& wget -qO- https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \
		| sh -s -- -b /usr/local/bin "v${TRIVY_VERSION}" \
	&& mkdir /tmp/cosign-build \
	&& cd /tmp/cosign-build \
	&& go mod init cosign-toolchain-build \
	&& go get github.com/sigstore/cosign/v2/cmd/cosign@v2.6.3 \
		github.com/docker/cli@v29.2.0+incompatible \
		github.com/go-jose/go-jose/v4@v4.1.4 \
		go.opentelemetry.io/otel@v1.43.0 \
		go.opentelemetry.io/otel/sdk@v1.43.0 \
		google.golang.org/grpc@v1.79.3 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/sigstore/cosign/v2/cmd/cosign

FROM alpine:3.23@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11

LABEL org.opencontainers.image.source="https://github.com/kitti12911/image-toolchain"
LABEL org.opencontainers.image.description="Trivy, Gitleaks, and Cosign supply-chain security toolchain"

RUN apk add --no-cache \
	ca-certificates \
	git

COPY --from=builder /go/bin/gitleaks /usr/local/bin/gitleaks
COPY --from=builder /usr/local/bin/trivy /usr/local/bin/trivy
COPY --from=builder /go/bin/cosign /usr/local/bin/cosign

WORKDIR /workspace
