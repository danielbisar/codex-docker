#!/bin/bash
set -euo pipefail

usage() {
    cat >&2 <<EOF
Usage: $0 [OPTIONS] PATH_TO_REPO

Arguments:
  PATH_TO_REPO   Local repository path to mount at /home/codex/src

Options:
  --auth-dir PATH   Host directory for Codex auth state (default: ./home_codex)
  --shell        Run /bin/bash inside the container instead of Codex
  -h, --help     Show this help message
EOF
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
auth_dir="$script_dir/home_codex"
shell=false
repo_path=""

while [ "$#" -gt 0 ]; do
    case "$1" in
        --auth-dir)
            if [ "$#" -lt 2 ]; then
                echo "error: --auth-dir requires a path" >&2
                usage
                exit 1
            fi
            auth_dir="$2"
            shift
            ;;
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

repo_path="$(cd "$repo_path" && pwd)"

if [ ! -d "$auth_dir" ]; then
    echo "error: missing auth directory: $auth_dir" >&2
    echo "run ./auth.sh first, or pass --auth-dir PATH" >&2
    exit 1
fi
auth_dir="$(cd "$auth_dir" && pwd)"

container_command=()
if [ "$shell" = true ]; then
    container_command=(/bin/bash)
fi

docker run -it --rm \
    -v "$auth_dir:/home/codex/.codex" \
    -v "$repo_path:/home/codex/src" \
    codex:latest \
    "${container_command[@]}"
