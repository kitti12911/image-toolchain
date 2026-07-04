# syntax=docker/dockerfile:1.7
FROM golang:1.26.4-alpine@sha256:3ad57304ad93bbec8548a0437ad9e06a455660655d9af011d58b993f6f615648

ENV npm_config_audit=false \
	npm_config_fund=false \
	npm_config_update_notifier=false

LABEL org.opencontainers.image.source="https://github.com/kitti12911/image-toolchain"
LABEL org.opencontainers.image.description="Semantic-release CI toolchain"

RUN apk upgrade --no-cache libcrypto3 libssl3 \
	&& apk add --no-cache \
	ca-certificates \
	git \
	nodejs \
	npm

RUN --mount=type=cache,target=/root/.npm \
	npm install --global \
		semantic-release@25.0.5 \
		@semantic-release/commit-analyzer@13.0.1 \
		@semantic-release/release-notes-generator@14.1.1 \
		@semantic-release/github@12.0.9 \
		conventional-changelog-conventionalcommits@9.3.1 \
	&& npm cache clean --force

WORKDIR /workspace
