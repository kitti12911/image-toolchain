#!/usr/bin/env sh
set -eu

version="${COSIGN_VERSION:-2.6.3}"
install_dir="${COSIGN_INSTALL_DIR:-/usr/local/bin}"
os="$(uname -s | tr '[:upper:]' '[:lower:]')"
arch="$(uname -m)"

case "${os}" in
	linux)
		;;
	*)
		echo "unsupported operating system for cosign install: ${os}; only linux is supported" >&2
		exit 2
		;;
esac

case "${arch}" in
	x86_64 | amd64)
		arch="amd64"
		;;
	aarch64 | arm64)
		arch="arm64"
		;;
	*)
		echo "unsupported architecture for cosign install: ${arch}" >&2
		exit 2
		;;
esac

mkdir -p "${install_dir}"
url="https://github.com/sigstore/cosign/releases/download/v${version}/cosign-${os}-${arch}"
target="${install_dir}/cosign"

if command -v curl >/dev/null 2>&1; then
	curl --fail --location --silent --show-error "${url}" --output "${target}"
elif command -v wget >/dev/null 2>&1; then
	wget -qO "${target}" "${url}"
else
	echo "curl or wget is required to install cosign" >&2
	exit 2
fi

chmod +x "${target}"
"${target}" version

if [ -n "${GITHUB_PATH:-}" ]; then
	echo "${install_dir}" >>"${GITHUB_PATH}"
fi
