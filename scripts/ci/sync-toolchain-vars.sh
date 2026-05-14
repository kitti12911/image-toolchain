#!/usr/bin/env sh
# Updates CI/CD variables with the latest published toolchain image digests.
#
# GitHub Actions: set GITHUB_ORG (org-level) or GITHUB_REPOS (space-separated
#   "owner/repo" list for repo-level). Requires GH_TOKEN with variables write.
# GitLab CI: uses GL_TOKEN / GITLAB_TOKEN and CI_PROJECT_NAMESPACE_ID
#   (auto-set by GitLab) to update group-level variables.
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

_gl_set() {
    var_name="$1"
    value="$2"
    gl_token="${GL_TOKEN:-${GITLAB_TOKEN:-}}"
    if [ -z "${gl_token}" ]; then
        printf 'ERROR: GL_TOKEN or GITLAB_TOKEN is required\n' >&2
        exit 1
    fi
    group_id="${GITLAB_VARS_GROUP_ID:-${CI_PROJECT_NAMESPACE_ID:?CI_PROJECT_NAMESPACE_ID is required}}"
    curl --silent --fail --show-error \
        --request PUT \
        --header "PRIVATE-TOKEN: ${gl_token}" \
        --form "value=${value}" \
        "${CI_SERVER_URL}/api/v4/groups/${group_id}/variables/${var_name}"
}

for image in image-toolchain migration-toolchain release-toolchain helm-toolchain security-toolchain supply-chain-toolchain; do
    ref="${registry}/${namespace}/${image}:${release_tag}"
    digest=$(docker buildx imagetools inspect "${ref}" --format '{{json .Manifest.Digest}}' | tr -d '"')
    full_ref="${registry}/${namespace}/${image}@${digest}"
    base_var=$(printf '%s_IMAGE' "${image}" | tr 'a-z-' 'A-Z_')

    if [ -n "${GITHUB_ACTIONS:-}" ]; then
        _gh_set "${base_var}" "${full_ref}"
        printf 'GitHub: updated %s\n' "${base_var}"
    elif [ -n "${GITLAB_CI:-}" ]; then
        _gl_set "CI_${base_var}" "${full_ref}"
        printf 'GitLab: updated CI_%s\n' "${base_var}"
    else
        printf 'ERROR: unknown CI platform (neither GITHUB_ACTIONS nor GITLAB_CI is set)\n' >&2
        exit 1
    fi
done
