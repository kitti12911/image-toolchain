# image-toolchain

Shared CI toolchain images for the homelab sandbox repositories.

## Images

| Image                | Purpose                                      |
| -------------------- | -------------------------------------------- |
| `image-toolchain`    | Go, protobuf, Buf, and code generation tools |
| `security-toolchain` | Go vulnerability and Semgrep scanners        |

Images are published to Zot:

```text
zot.kittiaccess.work/kitti12911/image-toolchain:vx.y.z
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
- fieldmapgen
- patchfieldgen

`security-toolchain` includes:

- govulncheck
- semgrep

## Available Commands

| Command                      | Description                           |
| ---------------------------- | ------------------------------------- |
| `make build`                 | Build both toolchain images locally   |
| `make build-image-toolchain` | Build the image generation toolchain  |
| `make build-security`        | Build the security scanning toolchain |
| `make check`                 | Verify expected tools inside images   |
| `make pretty`                | Format docs and config with Prettier  |
| `make markdownlint`          | Lint Markdown files                   |

## Publishing

Release Please creates semver GitHub releases from `main`. The image workflow
builds and scans both images for pull requests, then publishes signed semver
and `latest` tags to Zot when a release is published.

## Version Updates

Tool versions live in the image Dockerfiles. Renovate tracks Docker base
images, GitHub Actions, Go tool installs, and Python tool installs.
