FROM golang:1.26.3-alpine@sha256:91eda9776261207ea25fd06b5b7fed8d397dd2c0a283e77f2ab6e91bfa71079d

ENV PATH="/opt/sqlfluff/bin:${PATH}"

LABEL org.opencontainers.image.source="https://github.com/kitti12911/image-toolchain"
LABEL org.opencontainers.image.description="Go, protobuf, Buf, SQL migration, and custom generator CI toolchain"

RUN apk add --no-cache \
	ca-certificates \
	git \
	make \
	python3 \
	protobuf

RUN python3 -m venv /opt/sqlfluff \
	&& /opt/sqlfluff/bin/python -m pip install --no-cache-dir --upgrade pip \
	&& /opt/sqlfluff/bin/python -m pip install --no-cache-dir sqlfluff==4.1.0 \
	&& find /opt/sqlfluff -type d -name __pycache__ -prune -exec rm -rf {} +

RUN --mount=type=cache,target=/go/pkg/mod \
	--mount=type=cache,target=/root/.cache/go-build \
	go install github.com/bufbuild/buf/cmd/buf@v1.69.0 \
	&& go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.11 \
	&& go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.6.1 \
	&& go install github.com/kitti12911/lib-orm/v2/cmd/fieldmapgen@v2.6.0 \
	&& go install github.com/kitti12911/lib-orm/v2/cmd/patchfieldgen@v2.6.0 \
	&& go install github.com/pressly/goose/v3/cmd/goose@v3.27.1

WORKDIR /workspace
