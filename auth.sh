#!/bin/bash
set -euo pipefail

usage() {
    cat >&2 <<EOF
Usage: $0 [OPTIONS]

Options:
  --auth-dir PATH   Host directory for Codex auth state (default: ./home_codex)
  --image IMAGE     Docker image to run (default: codex:latest)
  -h, --help        Show this help message
EOF
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
auth_dir="$script_dir/home_codex"
image="codex:latest"

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
        --image)
            if [ "$#" -lt 2 ]; then
                echo "error: --image requires an image name" >&2
                usage
                exit 1
            fi
            image="$2"
            shift
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
            echo "error: unexpected argument: $1" >&2
            usage
            exit 1
            ;;
    esac
    shift
done

mkdir -p "$auth_dir"
auth_dir="$(cd "$auth_dir" && pwd)"

echo "Using auth directory: $auth_dir" >&2
echo "Starting Codex device authentication in $image..." >&2

docker run -it --rm \
    -v "$auth_dir:/home/codex/.codex" \
    "$image" \
    codex login --device-auth
