# Claude Code Third-Party Provider Launchers

This repository contains wrapper scripts for running the installed `claude`
CLI with Anthropic-compatible third-party model providers.

The scripts do not replace the official Claude Code installation. They only
set process-local environment variables before launching `claude`, so your
normal `claude` command remains unchanged.

## Supported Providers

- DeepSeek
- Kimi / Moonshot
- MiniMax
- GLM / Zhipu
- Qwen / DashScope

## Prerequisites

Install the official Claude Code CLI first:

```bash
npm install -g @anthropic-ai/claude-code
claude --version
```

Then use one of the provider scripts in this repository.

## Usage

Run the script from the project directory you want Claude Code to operate on.

For example, with DeepSeek:

```bash
cd /path/to/your/project
export DEEPSEEK_API_KEY="your-api-key"
/Users/Adam/Desktop/cc-src/scripts/claude-deepseek.sh
```

Non-interactive test:

```bash
/Users/Adam/Desktop/cc-src/scripts/claude-deepseek.sh -p "What model backend are you using?"
```

Other providers:

```bash
export KIMI_API_KEY="your-api-key"
/Users/Adam/Desktop/cc-src/scripts/claude-kimi.sh

export MINIMAX_API_KEY="your-api-key"
/Users/Adam/Desktop/cc-src/scripts/claude-minimax.sh

export GLM_API_KEY="your-api-key"
/Users/Adam/Desktop/cc-src/scripts/claude-glm.sh

export QWEN_API_KEY="your-api-key"
/Users/Adam/Desktop/cc-src/scripts/claude-qwen.sh
```

## Optional Aliases

Add aliases to your shell config if you want shorter commands:

```bash
alias claude-deepseek="/Users/Adam/Desktop/cc-src/scripts/claude-deepseek.sh"
alias claude-kimi="/Users/Adam/Desktop/cc-src/scripts/claude-kimi.sh"
alias claude-minimax="/Users/Adam/Desktop/cc-src/scripts/claude-minimax.sh"
alias claude-glm="/Users/Adam/Desktop/cc-src/scripts/claude-glm.sh"
alias claude-qwen="/Users/Adam/Desktop/cc-src/scripts/claude-qwen.sh"
```

Then run:

```bash
cd /path/to/your/project
claude-deepseek
```

## Configuration Isolation

Each script uses a separate Claude config directory by default:

- DeepSeek: `~/.claude-deepseek`
- Kimi: `~/.claude-kimi`
- MiniMax: `~/.claude-minimax`
- GLM: `~/.claude-glm`
- Qwen: `~/.claude-qwen`

This avoids mixing sessions, settings, and auth state with your official
Claude Code configuration in `~/.claude`.

You can override this if needed:

```bash
export CLAUDE_CONFIG_DIR="$HOME/.claude-custom"
```

## Custom Claude Binary

By default, scripts launch the `claude` command found in your `PATH`.

To use a custom binary:

```bash
export CLAUDE_BIN="/path/to/my-claude"
/Users/Adam/Desktop/cc-src/scripts/claude-deepseek.sh
```

## Network Notes

If you see `ConnectionRefused`, check your VPN or local proxy settings. This
usually means traffic was routed to a local proxy port that is not accepting
connections.

With system-level TUN mode, terminal traffic may already be routed by the VPN,
so shell proxy variables are often unnecessary. If needed, clear stale proxy
variables:

```bash
unset HTTP_PROXY HTTPS_PROXY ALL_PROXY http_proxy https_proxy all_proxy
```

You can test connectivity with:

```bash
curl -I https://api.deepseek.com/anthropic
```

`401`, `404`, or `405` still means the server is reachable. `Connection refused`,
DNS errors, or timeouts indicate a network/proxy problem.

## Notes

These scripts route Claude Code client requests to third-party providers. They
do not make the model locally self-hosted. If you use a cloud API provider, the
inference still runs on that provider's infrastructure.
