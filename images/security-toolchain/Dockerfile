# syntax=docker/dockerfile:1.7
FROM golang:1.26.4-alpine@sha256:3ad57304ad93bbec8548a0437ad9e06a455660655d9af011d58b993f6f615648

ENV PATH="/opt/semgrep/bin:${PATH}" \
	PIP_DISABLE_PIP_VERSION_CHECK=1 \
	PYTHONDONTWRITEBYTECODE=1

LABEL org.opencontainers.image.source="https://github.com/kitti12911/image-toolchain"
LABEL org.opencontainers.image.description="Go vulnerability and Semgrep CI security toolchain"

RUN apk upgrade --no-cache libcrypto3 libssl3 \
	&& apk add --no-cache \
	ca-certificates \
	git \
	python3

RUN --mount=type=cache,target=/root/.cache/pip \
	python3 -m venv /opt/semgrep \
	&& /opt/semgrep/bin/python -m pip install --upgrade pip

RUN --mount=type=cache,target=/root/.cache/pip \
	apk add --no-cache --virtual .strip-deps binutils \
	&& /opt/semgrep/bin/python -m pip install --no-compile semgrep==1.168.0 \
	&& strip --strip-unneeded /opt/semgrep/lib/python*/site-packages/semgrep/bin/semgrep-core \
	&& /opt/semgrep/bin/python -m pip uninstall -y pip \
	&& find /opt/semgrep -type d -name __pycache__ -prune -exec rm -rf {} + \
	&& apk del .strip-deps

RUN --mount=type=cache,target=/go/pkg/mod \
	--mount=type=cache,target=/root/.cache/go-build \
	CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" golang.org/x/vuln/cmd/govulncheck@v1.5.0

WORKDIR /workspace
