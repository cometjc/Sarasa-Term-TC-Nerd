#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

UV_PYTHON="${UV_PYTHON:-/usr/bin/python3}"
SARASA_ASSET_PATTERN="${SARASA_ASSET_PATTERN:-SarasaTermTC-TTF-[0-9.]+\\.7z}"
OUTPUT_SUFFIX="${OUTPUT_SUFFIX:-}"
SARASA_API="https://api.github.com/repos/be5invis/Sarasa-Gothic/releases"

require_command() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1" >&2
    exit 1
  }
}

download_with_aria2() {
  local url="$1"
  local output="$2"

  aria2c -c -x 8 -s 8 --summary-interval=10 -o "$output" "$url"
}

require_command aria2c
require_command curl
require_command jq
require_command 7zr
require_command uv
require_command git

if [[ ! -d nerd-fonts/.git && ! -f nerd-fonts/.git ]]; then
  git submodule update --init --depth 1 nerd-fonts
fi

if [[ ! -x .venv/bin/python ]]; then
  uv venv --python "$UV_PYTHON" --system-site-packages
fi
uv sync

echo "Verifying uv Python base"
if ! uv run python - <<'PY'
import fontforge
import fontTools
print("uv base imports ok")
PY
then
  rm -rf .venv
  uv venv --python "$UV_PYTHON" --system-site-packages
  uv sync
  uv run python - <<'PY'
import fontforge
import fontTools
print("uv base imports ok")
PY
fi

sarasa_url="$(curl -fsSL "$SARASA_API" | jq -r --arg asset_pattern "$SARASA_ASSET_PATTERN" '.[0].assets | map(.browser_download_url) | map(select(test($asset_pattern))) | .[0]')"
if [[ -z "$sarasa_url" || "$sarasa_url" == "null" ]]; then
  echo "Could not find SarasaTermTC release asset matching: $SARASA_ASSET_PATTERN" >&2
  exit 1
fi

sarasa_archive="${sarasa_url##*/}"
if [[ ! -f "$sarasa_archive" ]] || ! 7zr t "$sarasa_archive" >/dev/null 2>&1; then
  rm -f "$sarasa_archive" "$sarasa_archive".aria2
  download_with_aria2 "$sarasa_url" "$sarasa_archive"
  7zr t "$sarasa_archive" >/dev/null
fi

rm -rf sarasa
rm -f SarasaTermTC-*.ttf
7zr x -y "$sarasa_archive" >/tmp/sarasa-term-tc-7zr.log
mkdir -p sarasa
mv -f SarasaTermTC-*.ttf sarasa/

if ! grep -q 'SarasaTermTCNerd' nerd-fonts/font-patcher; then
  echo "nerd-fonts/font-patcher is not patched for Sarasa Term TC Nerd" >&2
  exit 1
fi

cp scripts/otf2otc.py otf2otc.py

rm -rf sarasa-nerd
bash -xeu scripts/build

if [[ -n "$OUTPUT_SUFFIX" ]]; then
  for ext in ttf.tar.gz ttc.tar.gz ttf.7z ttc.7z; do
    mv "sarasa-nerd/SarasaTermTCNerd.$ext" "sarasa-nerd/SarasaTermTCNerd$OUTPUT_SUFFIX.$ext"
  done
fi
