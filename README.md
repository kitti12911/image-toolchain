# image-toolchain

Shared CI toolchain images for the homelab sandbox repositories.

## Images

| Image                    | Purpose                                           |
| ------------------------ | ------------------------------------------------- |
| `image-toolchain`        | Go, protobuf, Buf, OpenAPI, lint, and code tools  |
| `migration-toolchain`    | SQLFluff and Goose migration validation           |
| `release-toolchain`      | semantic-release and conventional changelog tools |
| `helm-toolchain`         | Helm chart linting                                |
| `security-toolchain`     | Go vulnerability and Semgrep code scanners        |
| `supply-chain-toolchain` | Trivy, Gitleaks, and Cosign security tooling      |

Images are published to the configured registry:

```text
${TOOLCHAIN_REGISTRY}/${TOOLCHAIN_IMAGE_NAMESPACE}/image-toolchain:vx.y.z
${TOOLCHAIN_REGISTRY}/${TOOLCHAIN_IMAGE_NAMESPACE}/migration-toolchain:vx.y.z
${TOOLCHAIN_REGISTRY}/${TOOLCHAIN_IMAGE_NAMESPACE}/release-toolchain:vx.y.z
${TOOLCHAIN_REGISTRY}/${TOOLCHAIN_IMAGE_NAMESPACE}/helm-toolchain:vx.y.z
${TOOLCHAIN_REGISTRY}/${TOOLCHAIN_IMAGE_NAMESPACE}/security-toolchain:vx.y.z
${TOOLCHAIN_REGISTRY}/${TOOLCHAIN_IMAGE_NAMESPACE}/supply-chain-toolchain:vx.y.z
```

## Included Tools

`image-toolchain` includes:

- Go
- gcc + musl-dev (CGO and `go test -race` support)
- make
- git
- ca-certificates
- Buf
- golangci-lint
- oasdiff
- protoc
- protoc-gen-go
- protoc-gen-go-grpc
- fieldmapgen
- patchfieldgen
- protomapgen

`migration-toolchain` includes:

- make
- goose
- sqlfluff

`release-toolchain` includes:

- git
- Node.js
- npm
- semantic-release
- @semantic-release/commit-analyzer
- @semantic-release/release-notes-generator
- @semantic-release/github
- conventional-changelog-conventionalcommits

`helm-toolchain` includes:

- make
- Helm

`security-toolchain` includes:

- govulncheck
- semgrep

`supply-chain-toolchain` includes:

- Trivy
- Gitleaks
- Cosign

## Available Commands

| Command                      | Description                            |
| ---------------------------- | -------------------------------------- |
| `make build`                 | Build all toolchain images locally     |
| `make build-image-toolchain` | Build the Go/code generation toolchain |
| `make build-migration`       | Build the migration toolchain          |
| `make build-release`         | Build the release toolchain            |
| `make build-helm`            | Build the Helm toolchain               |
| `make build-security`        | Build the security scanning toolchain  |
| `make build-supply-chain`    | Build the supply-chain security tools  |
| `make check`                 | Verify expected tools inside images    |
| `make pretty`                | Format docs and config with Prettier   |
| `make markdownlint`          | Lint Markdown files                    |

## Publishing

Semantic-release creates semver releases from `main` through GitHub Actions.
Pull requests run a lightweight `linux/amd64` build and local Trivy scan. Main
branch pushes first calculate the next semantic-release tag; when a release is
needed, the workflow builds and pushes staging images, scans those staging
images, publishes the GitHub release only after the scans pass, and then
promotes the scanned staging images to signed semver and `latest` tags in the
configured registry.

## Portable CI Scripts

GitHub Actions workflows use official actions (`docker/setup-buildx-action`,
`docker/login-action`, `docker/build-push-action`, `aquasecurity/trivy-action`)
for buildx setup, registry login, image build/push, and Trivy scanning. The
reusable scripts under `scripts/ci/` cover the remaining shared work: manifest
promotion, multi-arch publishing, Cosign signing, and pinned semantic-release.

Common inputs (remaining scripts):

| Variable            | Description                                |
| ------------------- | ------------------------------------------ |
| `REGISTRY`          | Target registry host                       |
| `IMAGE_REF`         | Image repository without tag               |
| `RELEASE_TAG`       | Semver release tag                         |
| `IMAGE_ARCHES`      | Space-separated manifest arches            |
| `STAGING_IMAGE_REF` | Temporary image tag to scan before promote |
| `ARCH_IMAGE_REF`    | Architecture-specific release tag          |

GitHub requires these repository variables and secrets:

| Name                          | Type     | Description               |
| ----------------------------- | -------- | ------------------------- |
| `TOOLCHAIN_REGISTRY`          | Variable | Target registry host      |
| `TOOLCHAIN_IMAGE_NAMESPACE`   | Variable | Target registry namespace |
| `TOOLCHAIN_REGISTRY_USERNAME` | Secret   | Registry login username   |
| `TOOLCHAIN_REGISTRY_PASSWORD` | Secret   | Registry login token      |
| `COSIGN_PRIVATE_KEY`          | Secret   | Private key matching Zot  |

If the private key is encrypted, also pass `COSIGN_PASSWORD` from the GitHub
Actions secret store. The publish job installs Cosign in the Docker CLI job
image before calling `scripts/ci/sign-image.sh`.

## Version Updates

Tool versions live in the image Dockerfiles. Renovate tracks Docker base
images, GitHub Actions, Go tool installs, npm tool installs, and Python tool
installs.
