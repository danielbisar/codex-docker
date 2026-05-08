# Codex Docker Image

This repository builds a Docker image for running Codex in a container. The
image installs `@openai/codex`, `git`, and `ripgrep`, creates a non-root `codex`
user, and starts Codex from `/home/codex/src`.

## Requirements

- Docker
- A local checkout of this repository
- Codex authentication state, if you want to reuse an existing login

## Build

Build the image with the helper script:

```bash
./build.sh
```

The script tags the image as both `codex:0.129.0` and `codex:latest`.

You can also build directly:

```bash
docker build -t codex:latest .
```

## Authenticate

Follow `auth.md` to create a local `home_codex/` directory containing Codex
authentication state. That directory is mounted into containers as
`/home/codex/.codex`.

Treat `home_codex/` as sensitive local state. It can contain credentials, logs,
cache files, and other runtime data, and should not be committed (therefore ignored by Git)

## Run Codex Against a Repository

After building the image and creating `home_codex/`, run Codex against another
local repository with:

```bash
./run.sh /path/to/repo
```

The script mounts:

- `home_codex/` to `/home/codex/.codex`
- The target repository to `/home/codex/src`

Codex starts with:

```bash
codex --sandbox danger-full-access
```

To enter a shell in the container instead, run:

```bash
./run.sh --shell /path/to/repo
```

## Files

- `Dockerfile`: defines the Codex container image.
- `build.sh`: builds and tags the image.
- `run.sh`: runs Codex with authentication state and a mounted repository.
- `auth.md`: documents the manual device-auth setup flow.
