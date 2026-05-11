FROM golang:1.26.3-alpine@sha256:91eda9776261207ea25fd06b5b7fed8d397dd2c0a283e77f2ab6e91bfa71079d AS go-builder

RUN --mount=type=cache,target=/go/pkg/mod \
	--mount=type=cache,target=/root/.cache/go-build \
	CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/zricethezav/gitleaks/v8@v8.29.0 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/sigstore/cosign/v2/cmd/cosign@v2.6.3 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" golang.org/x/vuln/cmd/govulncheck@v1.3.0

FROM alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11

ENV PATH="/opt/semgrep/bin:${PATH}" \
	PIP_DISABLE_PIP_VERSION_CHECK=1 \
	PYTHONDONTWRITEBYTECODE=1

LABEL org.opencontainers.image.source="https://github.com/kitti12911/image-toolchain"
LABEL org.opencontainers.image.description="Vulnerability, static-analysis, secret, and signing CI security toolchain"

RUN apk add --no-cache \
	ca-certificates \
	curl \
	git \
	python3

RUN arch="$(apk --print-arch)" \
	&& case "${arch}" in \
		x86_64) go_arch="64bit" ;; \
		aarch64) go_arch="ARM64" ;; \
		*) echo "unsupported trivy architecture: ${arch}" >&2; exit 1 ;; \
	esac \
	&& curl -fsSLo /tmp/trivy.tar.gz "https://github.com/aquasecurity/trivy/releases/download/v0.70.0/trivy_0.70.0_Linux-${go_arch}.tar.gz" \
	&& tar -xzf /tmp/trivy.tar.gz -C /usr/local/bin trivy \
	&& rm -f /tmp/trivy.tar.gz

RUN --mount=type=cache,target=/root/.cache/pip \
	python3 -m venv /opt/semgrep \
	&& /opt/semgrep/bin/python -m pip install --upgrade pip

RUN --mount=type=cache,target=/root/.cache/pip \
	apk add --no-cache --virtual .strip-deps binutils \
	&& /opt/semgrep/bin/python -m pip install --no-compile semgrep==1.161.0 \
	&& strip --strip-unneeded /opt/semgrep/lib/python*/site-packages/semgrep/bin/semgrep-core \
	&& /opt/semgrep/bin/python -m pip uninstall -y pip \
	&& find /opt/semgrep -type d -name __pycache__ -prune -exec rm -rf {} + \
	&& apk del .strip-deps

COPY --from=go-builder /go/bin/gitleaks /usr/local/bin/gitleaks
COPY --from=go-builder /go/bin/cosign /usr/local/bin/cosign
COPY --from=go-builder /go/bin/govulncheck /usr/local/bin/govulncheck

WORKDIR /workspace
