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

Release Please creates semver GitHub releases from `main`. The image workflow
builds and scans all toolchain images for pull requests, then publishes signed
semver and `latest` tags to the configured registry when a release is
published.

## Portable CI Scripts

Provider workflows should keep orchestration in YAML and call the reusable
scripts under `scripts/ci/` for the shared container work. The scripts use raw
Docker, Trivy, and Cosign commands so GitHub Actions and GitLab CI can pass the
same inputs with different variable names.

Common inputs:

| Variable              | Description                                  |
| --------------------- | -------------------------------------------- |
| `REGISTRY`            | Target registry host                         |
| `REGISTRY_USERNAME`   | Registry login username                      |
| `REGISTRY_PASSWORD`   | Registry login token or password             |
| `IMAGE_CONTEXT`       | Docker build context, such as `images/image` |
| `IMAGE_PLATFORM`      | Docker platform, such as `linux/amd64`       |
| `IMAGE_TAG`           | Full image tag for `build-image.sh`          |
| `IMAGE_REF`           | Image repository without tag                 |
| `RELEASE_TAG`         | Semver release tag                           |
| `IMAGE_ARCHES`        | Space-separated manifest arches              |
| `STAGING_IMAGE_REF`   | Temporary image tag to scan before promote   |
| `ARCH_IMAGE_REF`      | Architecture-specific release tag            |
| `COSIGN_PRIVATE_KEY`  | Cosign signing key                           |
| `TRIVY_RUNNER_IMAGE`  | Optional Trivy container fallback image      |
| `COSIGN_RUNNER_IMAGE` | Optional Cosign container fallback image     |

GitHub requires these repository variables and secrets:

| Name                          | Type     | Description               |
| ----------------------------- | -------- | ------------------------- |
| `TOOLCHAIN_REGISTRY`          | Variable | Target registry host      |
| `TOOLCHAIN_IMAGE_NAMESPACE`   | Variable | Target registry namespace |
| `TOOLCHAIN_REGISTRY_USERNAME` | Secret   | Registry login username   |
| `TOOLCHAIN_REGISTRY_PASSWORD` | Secret   | Registry login token      |
| `COSIGN_PRIVATE_KEY`          | Secret   | Cosign signing key        |

GitLab should map its own CI variables into the same script inputs rather than
duplicating the build, scan, publish, and sign commands.

## Version Updates

Tool versions live in the image Dockerfiles. Renovate tracks Docker base
images, GitHub Actions, Go tool installs, npm tool installs, and Python tool
installs.
