#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

flavor="${FLAVOR:-hinted}"
if [[ -z "${FLAVOR:-}" && "${SARASA_ASSET_PATTERN:-}" == *Unhinted* ]]; then
  flavor="unhinted"
fi

args=(--flavor "$flavor" --jobs "${JOBS:-1}")
if [[ -n "${OUTPUT_SUFFIX:-}" ]]; then
  args+=(--output-suffix "$OUTPUT_SUFFIX")
fi

exec "$ROOT_DIR/scripts/ops/build-release" "${args[@]}"
