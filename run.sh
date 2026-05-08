#!/bin/bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 PATH_TO_REPO" >&2
    exit 1
fi

repo_path="$1"

if [ ! -d "$repo_path" ]; then
    echo "error: repo path does not exist or is not a directory: $repo_path" >&2
    exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_path="$(cd "$repo_path" && pwd)"

if [ ! -d "$script_dir/home_codex" ]; then
    echo "error: missing $script_dir/home_codex; follow auth.md to create it first" >&2
    exit 1
fi

docker run -it --rm \
    -v "$script_dir/home_codex:/home/codex/.codex" \
    -v "$repo_path:/home/codex/src" \
    codex:latest
