#!/usr/bin/env sh
set -eu

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

run_semantic_release "$@"
