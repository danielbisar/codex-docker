# Codex Docker Image

This repository builds a Docker image for running Codex in a container. The
image installs `@openai/codex`, `git`, and `ripgrep`, creates a non-root `codex`
user, and starts Codex from `/home/codex/src`.

## Requirements

- Docker
- A local checkout of this repository

## Quick Start

1. Build the image:

```bash
./build.sh
```

The script pulls the latest `node:24-slim` base image, tags the image as
`codex:latest`, reads the installed Codex version from inside the image, and
adds a matching `codex:<version>` tag. To skip the base-image pull, run
`./build.sh --no-pull`.

To change the base image, update `base_image` in `build.sh`; the script passes
that value into the Dockerfile.

2. Authenticate Codex:

```bash
./auth.sh
```

The script creates `home_codex/`, mounts it at `/home/codex/.codex` inside the
container, and runs `codex login --device-auth`. Follow the device-auth
instructions printed by Codex. When the command exits, the saved authentication
state remains in `home_codex/` on the host.

To use a different auth directory:

```bash
./auth.sh --auth-dir /path/to/codex-auth
```

3. Run Codex against a repository:

```bash
./run.sh /path/to/repo
```

To use a different auth directory when running:

```bash
./run.sh --auth-dir /path/to/codex-auth /path/to/repo
```

To enter a shell in the container instead of starting Codex:

```bash
./run.sh --shell /path/to/repo
```

`run.sh` mounts:

- The auth directory to `/home/codex/.codex`
- The target repository to `/home/codex/src`

## Direct Docker Commands

Build the image directly:

```bash
docker build -t codex:latest .
```

Open a shell for inspecting the image:

```bash
docker run -it --rm --entrypoint sh codex:latest
```

## Files

- `Dockerfile`: defines the Codex container image.
- `build.sh`: builds and tags the image.
- `auth.sh`: runs Codex device authentication with auth state mounted to `home_codex/`.
- `run.sh`: runs Codex or `/bin/bash` with authentication state and a mounted repository.
- `home_codex/`: local runtime state for Codex credentials, cache, logs, and configuration.

Treat `home_codex/` and any custom auth directory as sensitive local state. Do
not commit credentials, copied Codex state, or generated SQLite/log files.
