FROM golang:1.26.2-alpine@sha256:f85330846cde1e57ca9ec309382da3b8e6ae3ab943d2739500e08c86393a21b1

ENV PATH="/opt/semgrep/bin:${PATH}"

LABEL org.opencontainers.image.source="https://github.com/kitti12911/image-toolchain"
LABEL org.opencontainers.image.description="Go vulnerability and Semgrep CI security toolchain"

RUN apk add --no-cache \
	ca-certificates \
	git \
	python3

RUN python3 -m venv /opt/semgrep \
	&& /opt/semgrep/bin/python -m pip install --no-cache-dir --upgrade pip \
	&& /opt/semgrep/bin/python -m pip install --no-cache-dir semgrep==1.161.0

RUN --mount=type=cache,target=/go/pkg/mod \
	--mount=type=cache,target=/root/.cache/go-build \
	go install golang.org/x/vuln/cmd/govulncheck@v1.3.0

WORKDIR /workspace
