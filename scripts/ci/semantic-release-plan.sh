#!/usr/bin/env sh
set -eu

log_file="${SEMANTIC_RELEASE_LOG:-${RUNNER_TEMP:-/tmp}/semantic-release-dry-run.log}"

run_semantic_release() {
	if command -v semantic-release >/dev/null 2>&1; then
		semantic-release "$@"
		return
	fi

	npx --yes \
		--package semantic-release@25.0.3 \
		--package @semantic-release/commit-analyzer@13.0.1 \
		--package @semantic-release/release-notes-generator@14.1.1 \
		--package @semantic-release/github@12.0.8 \
		--package conventional-changelog-conventionalcommits@9.3.1 \
		semantic-release "$@"
}

set +e
run_semantic_release --dry-run >"${log_file}" 2>&1
status="$?"
set -e

cat "${log_file}"

if [ "${status}" -ne 0 ]; then
	exit "${status}"
fi

version="$(sed -n 's/.*The next release version is \([0-9][0-9.]*\).*/\1/p' "${log_file}" | tail -n 1)"

if [ -z "${version}" ]; then
	release_created=false
	tag_name=
else
	release_created=true
	tag_name="v${version}"
fi

echo "release_created=${release_created}"
if [ -n "${tag_name}" ]; then
	echo "tag_name=${tag_name}"
fi

if [ -n "${GITHUB_OUTPUT:-}" ]; then
	{
		echo "release_created=${release_created}"
		echo "tag_name=${tag_name}"
	} >>"${GITHUB_OUTPUT}"
fi
