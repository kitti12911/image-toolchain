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

Images are published to Zot:

```text
zot.kittiaccess.work/kitti12911/image-toolchain:vx.y.z
zot.kittiaccess.work/kitti12911/migration-toolchain:vx.y.z
zot.kittiaccess.work/kitti12911/release-toolchain:vx.y.z
zot.kittiaccess.work/kitti12911/helm-toolchain:vx.y.z
zot.kittiaccess.work/kitti12911/security-toolchain:vx.y.z
zot.kittiaccess.work/kitti12911/supply-chain-toolchain:vx.y.z
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
semver and `latest` tags to Zot when a release is published.

## Version Updates

Tool versions live in the image Dockerfiles. Renovate tracks Docker base
images, GitHub Actions, Go tool installs, npm tool installs, and Python tool
installs.
