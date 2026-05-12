#!/usr/bin/env bash
set -euo pipefail

API_KEY="${QWEN_API_KEY:-${DASHSCOPE_API_KEY:-${BAILIAN_API_KEY:-}}}"

if [[ -z "$API_KEY" ]]; then
  echo "Set QWEN_API_KEY, DASHSCOPE_API_KEY, or BAILIAN_API_KEY first." >&2
  exit 2
fi

if [[ -n "${QWEN_BASE_URL:-}" ]]; then
  BASE_URL="$QWEN_BASE_URL"
else
  case "${QWEN_PLAN:-payg}:${QWEN_REGION:-intl}" in
    coding:cn | coding:china | coding:mainland)
      BASE_URL="https://coding.dashscope.aliyuncs.com/apps/anthropic"
      ;;
    coding:*)
      BASE_URL="https://coding-intl.dashscope.aliyuncs.com/apps/anthropic"
      ;;
    payg:cn | payg:china | payg:mainland)
      BASE_URL="https://dashscope.aliyuncs.com/apps/anthropic"
      ;;
    payg:intl | payg:international | payg:global | payg:sg | payg:singapore)
      BASE_URL="https://dashscope-intl.aliyuncs.com/apps/anthropic"
      ;;
    *)
      echo "Unsupported QWEN_PLAN/QWEN_REGION: ${QWEN_PLAN:-payg}/${QWEN_REGION:-intl}." >&2
      echo "Use QWEN_BASE_URL to provide an explicit Anthropic-compatible endpoint." >&2
      exit 2
      ;;
  esac
fi

MODEL="${QWEN_MODEL:-qwen3.5-plus}"
SMALL_MODEL="${QWEN_SMALL_FAST_MODEL:-qwen3.5-flash}"

export ANTHROPIC_BASE_URL="$BASE_URL"
export ANTHROPIC_API_KEY="$API_KEY"
export ANTHROPIC_AUTH_TOKEN="$API_KEY"
export ANTHROPIC_MODEL="$MODEL"
export ANTHROPIC_DEFAULT_OPUS_MODEL="${QWEN_OPUS_MODEL:-$MODEL}"
export ANTHROPIC_DEFAULT_SONNET_MODEL="${QWEN_SONNET_MODEL:-$MODEL}"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="${QWEN_HAIKU_MODEL:-$SMALL_MODEL}"
export ANTHROPIC_SMALL_FAST_MODEL="$SMALL_MODEL"
export CLAUDE_CODE_SUBAGENT_MODEL="${QWEN_SUBAGENT_MODEL:-$SMALL_MODEL}"
export CLAUDE_CODE_EFFORT_LEVEL="${QWEN_EFFORT_LEVEL:-unset}"

export API_TIMEOUT_MS="${API_TIMEOUT_MS:-3000000}"
export ENABLE_TOOL_SEARCH="${ENABLE_TOOL_SEARCH:-0}"
export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS="${CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS:-1}"
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC="${CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC:-1}"
export DISABLE_TELEMETRY="${DISABLE_TELEMETRY:-1}"
export CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude-qwen}"

CLAUDE_BIN="${CLAUDE_BIN:-claude}"
exec "$CLAUDE_BIN" --bare --thinking "${QWEN_THINKING:-disabled}" "$@"
