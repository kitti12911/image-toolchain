# syntax=docker/dockerfile:1.7
FROM golang:1.26.4-alpine@sha256:3ad57304ad93bbec8548a0437ad9e06a455660655d9af011d58b993f6f615648 AS builder

RUN apk add --no-cache \
	ca-certificates \
	git

RUN --mount=type=cache,target=/go/pkg/mod \
	--mount=type=cache,target=/root/.cache/go-build \
	mkdir /tmp/gitleaks-build \
	&& cd /tmp/gitleaks-build \
	&& go mod init gitleaks-toolchain-build \
	&& go get github.com/zricethezav/gitleaks/v8@v8.30.1 \
		github.com/mholt/archives@v0.1.5 \
		github.com/nwaples/rardecode/v2@v2.2.0 \
		github.com/ulikunitz/xz@v0.5.15 \
		golang.org/x/crypto@v0.53.0 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/zricethezav/gitleaks/v8 \
	&& mkdir /tmp/trivy-build \
	&& cd /tmp/trivy-build \
	&& go mod init trivy-toolchain-build \
	&& go get github.com/aquasecurity/trivy/cmd/trivy@v0.72.0 \
		github.com/containerd/containerd@v1.7.33 \
		github.com/containerd/containerd/v2@v2.3.2 \
		github.com/go-git/go-git/v5@v5.19.1 \
		github.com/in-toto/in-toto-golang@v0.11.0 \
		github.com/nwaples/rardecode/v2@v2.2.0 \
		github.com/ulikunitz/xz@v0.5.15 \
		golang.org/x/crypto@v0.53.0 \
		oras.land/oras-go/v2@v2.6.1 \
	&& GOEXPERIMENT=jsonv2 CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/aquasecurity/trivy/cmd/trivy \
	&& mkdir /tmp/cosign-build \
	&& cd /tmp/cosign-build \
	&& go mod init cosign-toolchain-build \
	&& go get github.com/sigstore/cosign/v2/cmd/cosign@v2.6.3 \
		github.com/containerd/containerd@v1.7.33 \
		github.com/containerd/containerd/v2@v2.2.4 \
		github.com/docker/cli@v29.4.0+incompatible \
		github.com/go-jose/go-jose/v4@v4.1.4 \
		github.com/in-toto/in-toto-golang@v0.11.0 \
		github.com/sigstore/fulcio@v1.8.6 \
		github.com/sigstore/rekor@v1.5.2 \
		github.com/sigstore/sigstore@v1.10.6 \
		github.com/sigstore/timestamp-authority/v2@v2.0.6 \
		github.com/theupdateframework/go-tuf/v2@v2.4.1 \
		go.opentelemetry.io/otel@v1.43.0 \
		go.opentelemetry.io/otel/sdk@v1.43.0 \
		golang.org/x/crypto@v0.53.0 \
		golang.org/x/net@v0.55.0 \
		google.golang.org/grpc@v1.81.1 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/sigstore/cosign/v2/cmd/cosign

FROM alpine:3.23@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11

LABEL org.opencontainers.image.source="https://github.com/kitti12911/image-toolchain"
LABEL org.opencontainers.image.description="Trivy, Gitleaks, and Cosign supply-chain security toolchain"

RUN apk upgrade --no-cache libcrypto3 libssl3 \
	&& apk add --no-cache \
	ca-certificates \
	git

COPY --from=builder /go/bin/gitleaks /usr/local/bin/gitleaks
COPY --from=builder /go/bin/trivy /usr/local/bin/trivy
COPY --from=builder /go/bin/cosign /usr/local/bin/cosign

WORKDIR /workspace
