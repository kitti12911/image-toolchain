#!/usr/bin/env sh
set -eu

report="${1:?report path is required}"

if [ ! -s "${report}" ]; then
	echo "Trivy did not write a report: ${report}" >&2
	exit 1
fi

finding_count="$(jq '[.Results[]? | (.Vulnerabilities // [])[]] | length' "${report}")"
if [ "${finding_count}" -eq 0 ]; then
	echo "No HIGH/CRITICAL vulnerabilities detected."
	exit 0
fi

echo "Detected ${finding_count} HIGH/CRITICAL vulnerabilities:"
jq -r '
	.Results[]? as $result
	| ($result.Vulnerabilities // [])[]
	| "- [\(.Severity)] \(.VulnerabilityID) \(.PkgName) \(.InstalledVersion) -> \((.FixedVersion // "") | if . == "" then "no fix" else . end) (\($result.Target))"
' "${report}"

exit 1
