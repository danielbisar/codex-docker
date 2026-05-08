#!/bin/bash
set -euo pipefail

image="codex"
base_image="node:24-slim"
pull=true

usage() {
    cat >&2 <<EOF
Usage: $0 [OPTIONS]

Options:
  --no-pull   Skip pulling $base_image before building
  -h, --help  Show this help message
EOF
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --no-pull)
            pull=false
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

if [ "$pull" = true ]; then
    docker pull "$base_image"
fi

docker build --build-arg "BASE_IMAGE=$base_image" -t "$image:latest" .

version="$(
    docker run --rm "$image:latest" codex --version \
        | awk '$1 == "codex-cli" { print $2 }'
)"

if [ -z "$version" ]; then
    echo "error: could not determine Codex version from image" >&2
    exit 1
fi

docker tag "$image:latest" "$image:$version"

echo "Built $image:latest and $image:$version"
