FROM golang:1.26.3-alpine@sha256:91eda9776261207ea25fd06b5b7fed8d397dd2c0a283e77f2ab6e91bfa71079d

ENV PATH="/opt/sqlfluff/bin:${PATH}" \
	PIP_DISABLE_PIP_VERSION_CHECK=1 \
	PYTHONDONTWRITEBYTECODE=1

LABEL org.opencontainers.image.source="https://github.com/kitti12911/image-toolchain"
LABEL org.opencontainers.image.description="Go, protobuf, OpenAPI, Helm, and linting CI toolchain"

RUN apk add --no-cache \
	ca-certificates \
	curl \
	git \
	make \
	python3 \
	protobuf

RUN --mount=type=cache,target=/root/.cache/pip \
	python3 -m venv /opt/sqlfluff \
	&& /opt/sqlfluff/bin/python -m pip install --upgrade pip \
	&& /opt/sqlfluff/bin/python -m pip install --no-compile sqlfluff==4.1.0 \
	&& /opt/sqlfluff/bin/python -m pip uninstall -y pip \
	&& find /opt/sqlfluff -type d -name __pycache__ -prune -exec rm -rf {} +

RUN --mount=type=cache,target=/go/pkg/mod \
	--mount=type=cache,target=/root/.cache/go-build \
	CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/bufbuild/buf/cmd/buf@v1.69.0 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.11 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.6.1 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/kitti12911/lib-orm/v2/cmd/fieldmapgen@v2.6.0 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/kitti12911/lib-orm/v2/cmd/patchfieldgen@v2.6.0 \
	&& CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/pressly/goose/v3/cmd/goose@v3.27.1

RUN --mount=type=cache,target=/go/pkg/mod \
	--mount=type=cache,target=/root/.cache/go-build \
	CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.12.1

RUN --mount=type=cache,target=/go/pkg/mod \
	--mount=type=cache,target=/root/.cache/go-build \
	CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" github.com/oasdiff/oasdiff@v1.14.0

RUN arch="$(apk --print-arch)" \
	&& case "${arch}" in \
		x86_64) helm_arch="amd64" ;; \
		aarch64) helm_arch="arm64" ;; \
		*) echo "unsupported helm architecture: ${arch}" >&2; exit 1 ;; \
	esac \
	&& curl -fsSLo /tmp/helm.tar.gz "https://get.helm.sh/helm-v3.18.4-linux-${helm_arch}.tar.gz" \
	&& tar -xzf /tmp/helm.tar.gz -C /tmp \
	&& mv "/tmp/linux-${helm_arch}/helm" /usr/local/bin/helm \
	&& rm -rf /tmp/helm.tar.gz "/tmp/linux-${helm_arch}"

WORKDIR /workspace
