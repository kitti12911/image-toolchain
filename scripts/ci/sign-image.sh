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

runner_image="${COSIGN_RUNNER_IMAGE:-gcr.io/projectsigstore/cosign:v2.6.3}"
docker_config="${DOCKER_CONFIG:-${HOME}/.docker}"
export COSIGN_PRIVATE_KEY="${COSIGN_PRIVATE_KEY:?COSIGN_PRIVATE_KEY is required}"

for ref in "$@"; do
	docker run --rm \
		-e COSIGN_PRIVATE_KEY \
		-e DOCKER_CONFIG=/root/.docker \
		-v "${docker_config}:/root/.docker:ro" \
		"${runner_image}" sign --yes \
		--new-bundle-format=false \
		--use-signing-config=false \
		--key env://COSIGN_PRIVATE_KEY \
		"${ref}"
done
