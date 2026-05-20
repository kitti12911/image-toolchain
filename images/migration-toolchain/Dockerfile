FROM golang:1.26.3-alpine@sha256:91eda9776261207ea25fd06b5b7fed8d397dd2c0a283e77f2ab6e91bfa71079d

ENV PATH="/opt/sqlfluff/bin:${PATH}" \
	PIP_DISABLE_PIP_VERSION_CHECK=1 \
	PYTHONDONTWRITEBYTECODE=1

LABEL org.opencontainers.image.source="https://github.com/kitti12911/image-toolchain"
LABEL org.opencontainers.image.description="SQLFluff and Goose migration CI toolchain"

RUN apk add --no-cache \
	ca-certificates \
	make \
	python3

RUN --mount=type=cache,target=/root/.cache/pip \
	python3 -m venv /opt/sqlfluff \
	&& /opt/sqlfluff/bin/python -m pip install --upgrade pip \
	&& /opt/sqlfluff/bin/python -m pip install --no-compile sqlfluff==4.2.0 \
	&& /opt/sqlfluff/bin/python -m pip uninstall -y pip \
	&& find /opt/sqlfluff -type d -name __pycache__ -prune -exec rm -rf {} +

RUN --mount=type=cache,target=/go/pkg/mod \
	--mount=type=cache,target=/root/.cache/go-build \
	CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/pressly/goose/v3/cmd/goose@v3.27.1

WORKDIR /workspace
