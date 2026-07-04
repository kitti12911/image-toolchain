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

# Only image-toolchain remains; the loop is kept so re-adding images is a
# one-line change. shellcheck disable=SC2043 (intentional single-item loop).
# shellcheck disable=SC2043
for image in image-toolchain; do
    ref="${registry}/${namespace}/${image}:${release_tag}"
    # set -e does not catch a failed inspect inside a pipe, so capture its
    # exit status explicitly and reject empty/"null" digests before writing
    # the variable. Otherwise consumers end up with refs like "image@" and
    # docker pull fails with "invalid reference format".
    digest_raw=$(docker buildx imagetools inspect "${ref}" --format '{{json .Manifest.Digest}}') || {
        printf 'ERROR: docker buildx imagetools inspect failed for %s\n' "${ref}" >&2
        exit 1
    }
    digest=$(printf '%s' "${digest_raw}" | tr -d '"')
    if [ -z "${digest}" ] || [ "${digest}" = "null" ]; then
        printf 'ERROR: empty digest returned for %s\n' "${ref}" >&2
        exit 1
    fi

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
