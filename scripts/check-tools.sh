#!/usr/bin/env sh
set -eu

image="${1:?image is required}"
profile="${2:?profile is required}"

case "${profile}" in
	image)
		docker run --rm "${image}" go version
		docker run --rm "${image}" make --version
		docker run --rm "${image}" git --version
		docker run --rm "${image}" buf --version
		docker run --rm "${image}" protoc --version
		docker run --rm "${image}" protoc-gen-go --version
		docker run --rm "${image}" protoc-gen-go-grpc --version
		docker run --rm "${image}" golangci-lint version
		docker run --rm "${image}" fieldmapgen -h
		docker run --rm "${image}" patchfieldgen -h
		docker run --rm "${image}" goose -version
		docker run --rm "${image}" sqlfluff --version
		docker run --rm "${image}" helm version --short
		docker run --rm "${image}" oasdiff --help
		;;
	release)
		docker run --rm "${image}" git --version
		docker run --rm "${image}" node --version
		docker run --rm "${image}" npm --version
		docker run --rm "${image}" markdownlint-cli2 --version
		docker run --rm "${image}" release-please --version
		docker run --rm "${image}" semantic-release --version
		docker run --rm "${image}" npm list --global --depth=0 \
			@semantic-release/commit-analyzer \
			@semantic-release/github \
			@semantic-release/gitlab \
			@semantic-release/release-notes-generator \
			conventional-changelog-conventionalcommits
		;;
	security)
		docker run --rm "${image}" govulncheck -version
		docker run --rm "${image}" semgrep --version
		docker run --rm "${image}" trivy --version
		docker run --rm "${image}" gitleaks version
		docker run --rm "${image}" cosign version
		;;
	*)
		echo "unknown profile: ${profile}" >&2
		exit 2
		;;
esac
