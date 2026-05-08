# Repository Guidelines

## Project Structure & Module Organization

This repository defines a Docker image for running Codex in a container.

- `Dockerfile` installs `@openai/codex` and devtools and uses codex user.
- `build.sh` defines the base image, pulls it by default, builds the image, reads the installed Codex version from the image, and tags it as both `codex:<version>` and `codex:latest`.
- `auth.sh` runs Codex device authentication with auth state mounted to `home_codex/`.
- `README.md` documents the build, authentication, and run workflow.
- `home_codex/` is local runtime state for Codex credentials, cache, logs, and configuration. It is ignored by Git and should not be committed.

There are no application source modules, tests, or assets beyond the container setup files.

## Build, Test, and Development Commands

- `./build.sh`: build the Docker image using the repository `Dockerfile`.
- `./build.sh --no-pull`: build the Docker image without first pulling `node:24-slim`.
- `./auth.sh`: run Codex device authentication and save state into `home_codex/`.
- `./run.sh PATH_TO_REPO`: run Codex in the container with `home_codex/` and the target repository mounted.
- `./run.sh --auth-dir PATH_TO_AUTH PATH_TO_REPO`: run Codex using a custom auth-state directory.
- `./run.sh --shell PATH_TO_REPO`: open `/bin/bash` in the container with the same mounts instead of starting Codex.
- `docker build -t codex:latest .`: build the image directly when testing Dockerfile changes.
- `docker run -it --rm codex:latest`: start Codex with the default container command.
- `docker run -it --rm --entrypoint sh codex:latest`: open a shell for inspecting the image or running authentication setup.

No automated test suite is present; validate by rebuilding the image and running a container.

## Coding Style & Naming Conventions

Keep shell scripts Bash-compatible and concise. Use readable continuation indentation for long Docker or shell commands. Prefer explicit package lists and remove apt cache files in the same `RUN` layer:

```Dockerfile
RUN apt-get update \
 && apt-get install -y --no-install-recommends git ripgrep \
 && rm -rf /var/lib/apt/lists/*
```

Use lowercase, descriptive filenames unless following conventions such as `Dockerfile` or `AGENTS.md`.

## Testing Guidelines

For Dockerfile changes, run `./build.sh`, then start a disposable container and verify key tools:

```bash
docker run -it --rm --entrypoint sh codex:latest
codex --version
git --version
rg --version
```

For authentication changes, run `./auth.sh` in a fresh container and confirm that mounting `home_codex/` avoids repeated device authentication.

## Commit & Pull Request Guidelines

The Git history uses short, imperative summaries such as `move to yolo mode inside the container; add git and ripgrep` and `Fix: device code authentication not working`. Keep commits focused.

Pull requests should include a brief summary, the build or manual validation performed, and any changes to authentication or mounted directory behavior. Include terminal output snippets when useful.

## Security & Configuration Tips

Treat `home_codex/` as sensitive local state because it can contain authentication data and logs. Do not commit credentials, copied Codex state, or generated SQLite/log files. If changing user IDs, mounted paths, authentication flow, or sandbox flags, update `README.md`.
