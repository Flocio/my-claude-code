#!/usr/bin/env bash
set -euo pipefail

API_KEY="${MINIMAX_API_KEY:-}"

if [[ -z "$API_KEY" ]]; then
  echo "Set MINIMAX_API_KEY first." >&2
  exit 2
fi

if [[ -n "${MINIMAX_BASE_URL:-}" ]]; then
  BASE_URL="$MINIMAX_BASE_URL"
else
  case "${MINIMAX_REGION:-intl}" in
    cn | china | mainland)
      BASE_URL="https://api.minimaxi.com/anthropic"
      ;;
    intl | international | global)
      BASE_URL="https://api.minimax.io/anthropic"
      ;;
    *)
      echo "Unsupported MINIMAX_REGION: ${MINIMAX_REGION}. Use intl or cn." >&2
      exit 2
      ;;
  esac
fi

MODEL="${MINIMAX_MODEL:-MiniMax-M2.7}"

export ANTHROPIC_BASE_URL="$BASE_URL"
export ANTHROPIC_API_KEY="$API_KEY"
export ANTHROPIC_AUTH_TOKEN="$API_KEY"
export ANTHROPIC_MODEL="$MODEL"
export ANTHROPIC_DEFAULT_OPUS_MODEL="${MINIMAX_OPUS_MODEL:-$MODEL}"
export ANTHROPIC_DEFAULT_SONNET_MODEL="${MINIMAX_SONNET_MODEL:-$MODEL}"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="${MINIMAX_HAIKU_MODEL:-$MODEL}"
export ANTHROPIC_SMALL_FAST_MODEL="${MINIMAX_SMALL_FAST_MODEL:-$MODEL}"
export CLAUDE_CODE_SUBAGENT_MODEL="${MINIMAX_SUBAGENT_MODEL:-${MINIMAX_SMALL_FAST_MODEL:-$MODEL}}"
export CLAUDE_CODE_EFFORT_LEVEL="${MINIMAX_EFFORT_LEVEL:-unset}"

export API_TIMEOUT_MS="${API_TIMEOUT_MS:-3000000}"
export ENABLE_TOOL_SEARCH="${ENABLE_TOOL_SEARCH:-0}"
export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS="${CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS:-1}"
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC="${CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC:-1}"
export DISABLE_TELEMETRY="${DISABLE_TELEMETRY:-1}"

CLAUDE_BIN="${CLAUDE_BIN:-claude}"
exec "$CLAUDE_BIN" --bare --thinking "${MINIMAX_THINKING:-disabled}" "$@"
