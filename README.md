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
- @semantic-release/gitlab
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

Semantic-release creates semver releases from `main` on the current CI provider.
Pull requests or merge requests run a lightweight `linux/amd64` build and local
Trivy scan. Main branch pushes first calculate the next semantic-release tag;
when a release is needed, the workflow builds and pushes staging images, scans
those staging images, publishes the provider release only after the scans pass,
and then promotes the scanned staging images to signed semver and `latest` tags
in the configured registry.

## Portable CI Scripts

Provider workflows should keep orchestration in YAML and call the reusable
scripts under `scripts/ci/` for the shared container work. The scripts use raw
Docker commands, containerized Trivy, runner-installed Cosign key-pair signing,
and pinned semantic-release packages so CI systems can pass the same inputs with
different variable names.

Common inputs:

| Variable             | Description                                  |
| -------------------- | -------------------------------------------- |
| `REGISTRY`           | Target registry host                         |
| `REGISTRY_USERNAME`  | Registry login username                      |
| `REGISTRY_PASSWORD`  | Registry login token or password             |
| `IMAGE_CONTEXT`      | Docker build context, such as `images/image` |
| `IMAGE_PLATFORM`     | Docker platform, such as `linux/amd64`       |
| `IMAGE_TAG`          | Full image tag for `build-image.sh`          |
| `IMAGE_REF`          | Image repository without tag                 |
| `RELEASE_TAG`        | Semver release tag                           |
| `IMAGE_ARCHES`       | Space-separated manifest arches              |
| `STAGING_IMAGE_REF`  | Temporary image tag to scan before promote   |
| `ARCH_IMAGE_REF`     | Architecture-specific release tag            |
| `TRIVY_RUNNER_IMAGE` | Optional Trivy container image               |

GitHub requires these repository variables and secrets:

| Name                          | Type     | Description               |
| ----------------------------- | -------- | ------------------------- |
| `TOOLCHAIN_REGISTRY`          | Variable | Target registry host      |
| `TOOLCHAIN_IMAGE_NAMESPACE`   | Variable | Target registry namespace |
| `TOOLCHAIN_REGISTRY_USERNAME` | Secret   | Registry login username   |
| `TOOLCHAIN_REGISTRY_PASSWORD` | Secret   | Registry login token      |
| `COSIGN_PRIVATE_KEY`          | Secret   | Private key matching Zot  |

GitLab uses `.gitlab-ci.yml` as the provider wrapper around the same scripts.
The pipeline publishes amd64-only images because the GitLab deployment target is
amd64-only. It expects a Docker-capable amd64 runner selected by runner tag. The
default tag matches the current private runner; override this GitLab variable if
your runner uses a different name:

| Name                      | Default                            | Description                 |
| ------------------------- | ---------------------------------- | --------------------------- |
| `GITLAB_AMD64_RUNNER_TAG` | `solution-principle.gitlab-bu8-sd` | Runner tag for amd64 builds |

GitLab requires these variables and secrets:

| Name                          | Type     | Description                               |
| ----------------------------- | -------- | ----------------------------------------- |
| `TOOLCHAIN_REGISTRY`          | Variable | Target registry host                      |
| `TOOLCHAIN_IMAGE_NAMESPACE`   | Variable | Target registry namespace                 |
| `TOOLCHAIN_REGISTRY_USERNAME` | Secret   | Registry login username                   |
| `TOOLCHAIN_REGISTRY_PASSWORD` | Secret   | Registry login token                      |
| `GITLAB_TOKEN` or `GL_TOKEN`  | Secret   | GitLab API token for semantic-release     |
| `COSIGN_PRIVATE_KEY`          | Secret   | Private key matching the trusted registry |

Use a project access token, group access token, or personal access token with
Developer or higher role. The token needs `api` for GitLab releases and
`write_repository` for semantic-release tag pushes in a private repository.

If the private key is encrypted, also pass `COSIGN_PASSWORD` from the CI
provider's secret store. The GitLab publish job installs Cosign in the Docker
CLI job image before calling `scripts/ci/sign-image.sh`.

## Version Updates

Tool versions live in the image Dockerfiles. Renovate tracks Docker base
images, GitHub Actions, Go tool installs, npm tool installs, and Python tool
installs.
