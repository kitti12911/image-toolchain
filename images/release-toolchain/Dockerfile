FROM golang:1.26.3-alpine@sha256:91eda9776261207ea25fd06b5b7fed8d397dd2c0a283e77f2ab6e91bfa71079d

ENV npm_config_audit=false \
	npm_config_fund=false \
	npm_config_update_notifier=false

LABEL org.opencontainers.image.source="https://github.com/kitti12911/image-toolchain"
LABEL org.opencontainers.image.description="Semantic-release CI toolchain"

RUN apk add --no-cache \
	ca-certificates \
	git \
	nodejs \
	npm

RUN --mount=type=cache,target=/root/.npm \
	npm install --global \
		semantic-release@25.0.3 \
		@semantic-release/commit-analyzer@13.0.1 \
		@semantic-release/release-notes-generator@14.1.1 \
		@semantic-release/github@12.0.8 \
		conventional-changelog-conventionalcommits@9.3.1 \
	&& npm cache clean --force

WORKDIR /workspace
