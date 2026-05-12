#!/usr/bin/env sh
set -eu

if [ "$#" -eq 0 ]; then
	image_ref="${IMAGE_REF:?IMAGE_REF is required when no digest refs are passed}"
	release_tag="${RELEASE_TAG:?RELEASE_TAG is required when no digest refs are passed}"
	arches="${IMAGE_ARCHES:-amd64 arm64}"

	digest="$(docker buildx imagetools inspect "${image_ref}:${release_tag}" --format '{{.Manifest.Digest}}')"
	set -- "${image_ref}@${digest}"

	for arch in ${arches}; do
		arch_digest="$(docker buildx imagetools inspect "${image_ref}:${release_tag}-${arch}" --format '{{.Manifest.Digest}}')"
		set -- "$@" "${image_ref}@${arch_digest}"
	done
fi

for ref in "$@"; do
	cosign sign --yes \
		--new-bundle-format=false \
		--use-signing-config=false \
		"${ref}"
done
