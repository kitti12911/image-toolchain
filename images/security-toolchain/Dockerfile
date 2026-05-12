FROM golang:1.26.3-alpine@sha256:91eda9776261207ea25fd06b5b7fed8d397dd2c0a283e77f2ab6e91bfa71079d

ENV PATH="/opt/semgrep/bin:${PATH}" \
	PIP_DISABLE_PIP_VERSION_CHECK=1 \
	PYTHONDONTWRITEBYTECODE=1

LABEL org.opencontainers.image.source="https://github.com/kitti12911/image-toolchain"
LABEL org.opencontainers.image.description="Go vulnerability and Semgrep CI security toolchain"

RUN apk add --no-cache \
	ca-certificates \
	git \
	python3

RUN --mount=type=cache,target=/root/.cache/pip \
	python3 -m venv /opt/semgrep \
	&& /opt/semgrep/bin/python -m pip install --upgrade pip

RUN --mount=type=cache,target=/root/.cache/pip \
	apk add --no-cache --virtual .strip-deps binutils \
	&& /opt/semgrep/bin/python -m pip install --no-compile semgrep==1.162.0 \
	&& strip --strip-unneeded /opt/semgrep/lib/python*/site-packages/semgrep/bin/semgrep-core \
	&& /opt/semgrep/bin/python -m pip uninstall -y pip \
	&& find /opt/semgrep -type d -name __pycache__ -prune -exec rm -rf {} + \
	&& apk del .strip-deps

RUN --mount=type=cache,target=/go/pkg/mod \
	--mount=type=cache,target=/root/.cache/go-build \
	CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" golang.org/x/vuln/cmd/govulncheck@v1.3.0

WORKDIR /workspace
