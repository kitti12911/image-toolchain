# image-toolchain

Shared CI toolchain image for the homelab sandbox repositories.

## Images

| Image             | Purpose                                          |
| ----------------- | ------------------------------------------------ |
| `image-toolchain` | Go, protobuf, Buf, OpenAPI, lint, and code tools |

`image-toolchain` is the Docker builder base for the `grpc-sandbox`,
`oas-sandbox`, and `saga-sandbox` service images, whose Dockerfiles run
`buf generate` and `mapgen` during the build. All other CI work (lint, test,
security, migration, helm, release) now runs directly on GitHub-hosted runners
via official actions and `go install` / `pip install`, so the migration,
release, helm, security, and supply-chain toolchain images were retired.

The image is published to the configured registry:

```text
${TOOLCHAIN_REGISTRY}/${TOOLCHAIN_IMAGE_NAMESPACE}/image-toolchain:vx.y.z
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
- mapgen

## Available Commands

| Command                      | Description                            |
| ---------------------------- | -------------------------------------- |
| `make build`                 | Build the toolchain image locally      |
| `make build-image-toolchain` | Build the Go/code generation toolchain |
| `make check`                 | Verify expected tools inside the image |
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
