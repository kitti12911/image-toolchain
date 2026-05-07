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
		docker run --rm "${image}" fieldmapgen -h
		docker run --rm "${image}" patchfieldgen -h
		docker run --rm "${image}" goose -version
		docker run --rm "${image}" sqlfluff --version
		;;
	security)
		docker run --rm "${image}" govulncheck -version
		docker run --rm "${image}" semgrep --version
		;;
	*)
		echo "unknown profile: ${profile}" >&2
		exit 2
		;;
esac
