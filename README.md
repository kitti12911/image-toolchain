# image-toolchain

Shared CI toolchain images for the homelab sandbox repositories.

## Images

| Image                | Purpose                                                   |
| -------------------- | --------------------------------------------------------- |
| `image-toolchain`    | Go, protobuf, OpenAPI, Helm, and build linting tools      |
| `release-toolchain`  | Markdown and release automation tools                     |
| `security-toolchain` | Vulnerability, static-analysis, secret, and signing tools |

Images are published to Zot:

```text
zot.kittiaccess.work/kitti12911/image-toolchain:vx.y.z
zot.kittiaccess.work/kitti12911/release-toolchain:vx.y.z
zot.kittiaccess.work/kitti12911/security-toolchain:vx.y.z
```

## Included Tools

`image-toolchain` includes:

- Go
- make
- git
- ca-certificates
- Buf
- protoc
- protoc-gen-go
- protoc-gen-go-grpc
- golangci-lint
- fieldmapgen
- patchfieldgen
- goose
- sqlfluff
- Helm
- oasdiff

`release-toolchain` includes:

- git
- Node.js
- npm
- markdownlint-cli2
- release-please
- semantic-release
- @semantic-release/commit-analyzer
- @semantic-release/github
- @semantic-release/gitlab
- @semantic-release/release-notes-generator
- conventional-changelog-conventionalcommits

`security-toolchain` includes:

- govulncheck
- semgrep
- Trivy
- Gitleaks
- Cosign

## Available Commands

| Command                      | Description                            |
| ---------------------------- | -------------------------------------- |
| `make build`                 | Build all toolchain images locally     |
| `make build-image-toolchain` | Build the image generation toolchain   |
| `make build-release`         | Build the release automation toolchain |
| `make build-security`        | Build the security scanning toolchain  |
| `make check`                 | Verify expected tools inside images    |
| `make pretty`                | Format docs and config with Prettier   |
| `make markdownlint`          | Lint Markdown files                    |

## Publishing

Release Please creates semver GitHub releases from `main`. The image workflow
builds and scans all images for pull requests, then publishes signed semver and
`latest` tags to Zot when a release is published.

## Version Updates

Tool versions live in the image Dockerfiles. Renovate tracks Docker base
images, GitHub Actions, Go tool installs, Python tool installs, npm global
installs, and direct GitHub release downloads.
