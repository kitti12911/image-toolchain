#!/usr/bin/env sh
set -eu

image_ref="${IMAGE_REF:?IMAGE_REF is required}"
release_tag="${RELEASE_TAG:?RELEASE_TAG is required}"
arches="${IMAGE_ARCHES:-amd64 arm64}"

set -- docker buildx imagetools create \
	--tag "${image_ref}:${release_tag}" \
	--tag "${image_ref}:latest"

for arch in ${arches}; do
	set -- "$@" "${image_ref}:${release_tag}-${arch}"
done

"$@"
