#!/usr/bin/env sh
set -eu

staging_image_ref="${STAGING_IMAGE_REF:?STAGING_IMAGE_REF is required}"
arch_image_ref="${ARCH_IMAGE_REF:?ARCH_IMAGE_REF is required}"

docker buildx imagetools create \
	--tag "${arch_image_ref}" \
	"${staging_image_ref}"
