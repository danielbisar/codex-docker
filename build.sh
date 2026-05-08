#!/bin/bash
set -euo pipefail

image="codex"

docker build -t "$image:latest" .

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
