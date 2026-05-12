#!/usr/bin/env sh
set -eu

image_ref="${TRIVY_IMAGE_REF:?TRIVY_IMAGE_REF is required}"
report="${TRIVY_REPORT:?TRIVY_REPORT is required}"
severity="${TRIVY_SEVERITY:-CRITICAL,HIGH}"
exit_code="${TRIVY_EXIT_CODE:-0}"
ignore_unfixed="${TRIVY_IGNORE_UNFIXED:-true}"
image_src="${TRIVY_IMAGE_SRC:-}"
platform="${TRIVY_PLATFORM:-}"
quiet="${TRIVY_QUIET:-true}"

report_dir="$(dirname "${report}")"
report_file="$(basename "${report}")"
mkdir -p "${report_dir}"

set -- image \
	--format json \
	--output "${report}" \
	--exit-code "${exit_code}" \
	--severity "${severity}"

if [ "${ignore_unfixed}" = "true" ]; then
	set -- "$@" --ignore-unfixed
fi

if [ -n "${image_src}" ]; then
	set -- "$@" --image-src "${image_src}"
fi

if [ -n "${platform}" ]; then
	set -- "$@" --platform "${platform}"
fi

if [ "${quiet}" = "true" ]; then
	set -- "$@" --quiet
fi

set -- "$@" "${image_ref}"

if command -v trivy >/dev/null 2>&1; then
	trivy "$@"
	exit 0
fi

runner_image="${TRIVY_RUNNER_IMAGE:-aquasec/trivy:0.70.0}"
export TRIVY_USERNAME="${TRIVY_USERNAME:-}"
export TRIVY_PASSWORD="${TRIVY_PASSWORD:-}"

set -- image \
	--format json \
	--output "/trivy-output/${report_file}" \
	--exit-code "${exit_code}" \
	--severity "${severity}"

if [ "${ignore_unfixed}" = "true" ]; then
	set -- "$@" --ignore-unfixed
fi

if [ -n "${image_src}" ]; then
	set -- "$@" --image-src "${image_src}"
fi

if [ -n "${platform}" ]; then
	set -- "$@" --platform "${platform}"
fi

if [ "${quiet}" = "true" ]; then
	set -- "$@" --quiet
fi

set -- "$@" "${image_ref}"

if [ "${image_src}" = "remote" ]; then
	docker run --rm \
		-e TRIVY_USERNAME \
		-e TRIVY_PASSWORD \
		-v "${report_dir}:/trivy-output" \
		"${runner_image}" "$@"
	exit 0
fi

docker run --rm \
	-e TRIVY_USERNAME \
	-e TRIVY_PASSWORD \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v "${report_dir}:/trivy-output" \
	"${runner_image}" "$@"
