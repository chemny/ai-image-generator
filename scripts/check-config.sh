#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

load_env_file() {
  local env_file="$1"
  if [[ -f "$env_file" ]]; then
    set -a
    # shellcheck disable=SC1090
    source "$env_file"
    set +a
  fi
}

load_env_file "./.env"
load_env_file "${SKILL_DIR}/.env"

status="ok"

if ! command -v jq >/dev/null 2>&1; then
  echo "missing: jq"
  status="error"
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "missing: curl"
  status="error"
fi

if [[ -n "${NANO_BANANA_API_URL:-${NANOBANANA_API_URL:-}}" && -n "${NANO_BANANA_API_KEY:-${NANOBANANA_API_KEY:-}}" ]]; then
  echo "nano-banana: configured"
else
  echo "nano-banana: not fully configured"
fi

if [[ -n "${OPENAI_IMAGE_API_KEY:-}" ]]; then
  echo "openai: configured"
else
  echo "openai: not fully configured"
fi

if [[ "$status" == "error" ]]; then
  exit 1
fi
