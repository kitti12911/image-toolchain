#!/usr/bin/env sh
set -eu

image="${1:?image is required}"
profile="${2:?profile is required}"

case "${profile}" in
	image)
		docker run --rm "${image}" go version
		docker run --rm "${image}" gcc --version
		docker run --rm "${image}" make --version
		docker run --rm "${image}" git --version
		docker run --rm "${image}" buf --version
		docker run --rm "${image}" golangci-lint --version
		docker run --rm "${image}" oasdiff --version
		docker run --rm "${image}" protoc --version
		docker run --rm "${image}" protoc-gen-go --version
		docker run --rm "${image}" protoc-gen-go-grpc --version
		# The lib-orm generator exits non-zero on -h, so verify presence only.
		docker run --rm "${image}" sh -c 'command -v mapgen'
		;;
	*)
		echo "unknown profile: ${profile}" >&2
		exit 2
		;;
esac
