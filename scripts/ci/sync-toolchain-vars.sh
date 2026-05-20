#!/usr/bin/env sh
# Updates CI/CD variables with the latest published toolchain image digests.
#
# GitHub Actions: set GITHUB_ORG (org-level) or GITHUB_REPOS (space-separated
#   "owner/repo" list for repo-level). Requires GH_TOKEN with variables write.
set -eu

registry="${REGISTRY:?REGISTRY is required}"
namespace="${IMAGE_NAMESPACE:?IMAGE_NAMESPACE is required}"
release_tag="${RELEASE_TAG:?RELEASE_TAG is required}"

_gh_set() {
    var_name="$1"
    value="$2"
    if [ -n "${GITHUB_ORG:-}" ]; then
        gh variable set "${var_name}" --org "${GITHUB_ORG}" --body "${value}"
    elif [ -n "${GITHUB_REPOS:-}" ]; then
        for repo in ${GITHUB_REPOS}; do
            gh variable set "${var_name}" --repo "${repo}" --body "${value}"
        done
    else
        printf 'ERROR: set GITHUB_ORG (org-level) or GITHUB_REPOS (space-separated owner/repo list)\n' >&2
        exit 1
    fi
}

for image in image-toolchain migration-toolchain release-toolchain helm-toolchain security-toolchain supply-chain-toolchain; do
    ref="${registry}/${namespace}/${image}:${release_tag}"
    digest=$(docker buildx imagetools inspect "${ref}" --format '{{json .Manifest.Digest}}' | tr -d '"')
    full_ref="${registry}/${namespace}/${image}@${digest}"
    base_var=$(printf '%s_IMAGE' "${image}" | tr 'a-z-' 'A-Z_')

    if [ -n "${GITHUB_ACTIONS:-}" ]; then
        _gh_set "${base_var}" "${full_ref}"
        printf 'GitHub: updated %s\n' "${base_var}"
    else
        printf 'ERROR: GITHUB_ACTIONS is not set\n' >&2
        exit 1
    fi
done
