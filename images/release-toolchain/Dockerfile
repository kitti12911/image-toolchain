FROM alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11

LABEL org.opencontainers.image.source="https://github.com/kitti12911/image-toolchain"
LABEL org.opencontainers.image.description="Markdown and release automation CI toolchain"

RUN apk add --no-cache \
	ca-certificates \
	git \
	nodejs \
	npm

RUN npm install --global markdownlint-cli2@0.19.1 \
	&& npm cache clean --force

RUN npm install --global release-please@17.1.2 \
	&& npm cache clean --force

RUN npm install --global \
		semantic-release@24.2.7 \
		@semantic-release/commit-analyzer@13.0.1 \
		@semantic-release/release-notes-generator@14.1.0 \
		conventional-changelog-conventionalcommits@8.0.0 \
	&& npm cache clean --force

RUN npm install --global \
		@semantic-release/github@11.0.6 \
		@semantic-release/gitlab@13.2.8 \
	&& npm cache clean --force

WORKDIR /workspace
