#!/bin/bash
set -euo pipefail

usage() {
    cat >&2 <<EOF
Usage: $0 [OPTIONS] PATH_TO_REPO

Arguments:
  PATH_TO_REPO   Local repository path to mount at /home/codex/src

Options:
  --shell        Run /bin/bash inside the container instead of Codex
  -h, --help     Show this help message
EOF
}

shell=false
repo_path=""

while [ "$#" -gt 0 ]; do
    case "$1" in
        --shell)
            shell=true
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -*)
            echo "error: unknown option: $1" >&2
            usage
            exit 1
            ;;
        *)
            if [ -n "$repo_path" ]; then
                echo "error: multiple repo paths provided" >&2
                usage
                exit 1
            fi
            repo_path="$1"
            ;;
    esac
    shift
done

if [ -z "$repo_path" ]; then
    usage
    exit 1
fi

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

container_command=()
if [ "$shell" = true ]; then
    container_command=(/bin/bash)
fi

docker run -it --rm \
    -v "$script_dir/home_codex:/home/codex/.codex" \
    -v "$repo_path:/home/codex/src" \
    codex:latest \
    "${container_command[@]}"
