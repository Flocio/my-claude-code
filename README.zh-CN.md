# Claude Code 第三方模型启动脚本

这个目录提供了一组启动脚本，用来让已安装的 `claude` 命令行客户端连接到兼容 Anthropic API 的第三方模型服务。

这些脚本不会替换官方 Claude Code 安装，也不会覆盖你的系统 `claude` 命令。它们只是在启动 `claude` 前，为当前进程临时设置环境变量，所以你的官方 Claude Code 仍然可以正常使用。

## 支持的服务商

- DeepSeek
- Kimi / Moonshot
- MiniMax
- GLM / 智谱
- Qwen / DashScope

## 前置条件

先安装官方 Claude Code CLI：

```bash
npm install -g @anthropic-ai/claude-code
claude --version
```

然后使用本目录中的某个服务商启动脚本。

## 使用方法

请在你希望 Claude Code 操作的项目目录中运行脚本。

例如使用 DeepSeek：

```bash
cd /path/to/your/project
export DEEPSEEK_API_KEY="你的 API Key"
/Users/Adam/Desktop/cc-src/scripts/claude-deepseek.sh
```

非交互模式测试：

```bash
/Users/Adam/Desktop/cc-src/scripts/claude-deepseek.sh -p "你当前使用的模型后端是什么？"
```

其他服务商：

```bash
export KIMI_API_KEY="你的 API Key"
/Users/Adam/Desktop/cc-src/scripts/claude-kimi.sh

export MINIMAX_API_KEY="你的 API Key"
/Users/Adam/Desktop/cc-src/scripts/claude-minimax.sh

export GLM_API_KEY="你的 API Key"
/Users/Adam/Desktop/cc-src/scripts/claude-glm.sh

export QWEN_API_KEY="你的 API Key"
/Users/Adam/Desktop/cc-src/scripts/claude-qwen.sh
```

Kimi 默认使用 Moonshot Open Platform 兼容入口。如果要强制使用 Kimi Code
专用入口，可以设置 `KIMI_MODE=code`，但该入口可能需要 Kimi Code 专用的 key
或套餐。Moonshot Open Platform 默认走中国区入口；如果需要国际区入口，设置
`KIMI_REGION=intl`。

## 可选别名

如果想少输入路径，可以把别名加入你的 shell 配置文件：

```bash
alias claude-deepseek="/Users/Adam/Desktop/cc-src/scripts/claude-deepseek.sh"
alias claude-kimi="/Users/Adam/Desktop/cc-src/scripts/claude-kimi.sh"
alias claude-minimax="/Users/Adam/Desktop/cc-src/scripts/claude-minimax.sh"
alias claude-glm="/Users/Adam/Desktop/cc-src/scripts/claude-glm.sh"
alias claude-qwen="/Users/Adam/Desktop/cc-src/scripts/claude-qwen.sh"
```

之后就可以这样使用：

```bash
cd /path/to/your/project
claude-deepseek
```

## 配置隔离

每个脚本默认使用独立的 Claude 配置目录：

- DeepSeek：`~/.claude-deepseek`
- Kimi：`~/.claude-kimi`
- MiniMax：`~/.claude-minimax`
- GLM：`~/.claude-glm`
- Qwen：`~/.claude-qwen`

这样可以避免第三方模型会话、设置、认证状态和官方 Claude Code 的 `~/.claude` 配置混在一起。

如果需要，也可以手动覆盖：

```bash
export CLAUDE_CONFIG_DIR="$HOME/.claude-custom"
```

## 使用自定义 Claude 二进制

脚本默认启动 `PATH` 中找到的 `claude` 命令。

如果你有自己的 Claude Code 二进制，可以这样指定：

```bash
export CLAUDE_BIN="/path/to/my-claude"
/Users/Adam/Desktop/cc-src/scripts/claude-deepseek.sh
```

## 网络说明

如果看到 `ConnectionRefused`，请检查 VPN 或本地代理设置。这个错误通常表示流量被转发到了某个本地代理端口，但该端口没有服务在监听。

如果使用系统级 TUN 模式，终端流量通常已经被 VPN 接管，不一定需要额外设置 shell 代理变量。如果怀疑代理变量有问题，可以临时清理：

```bash
unset HTTP_PROXY HTTPS_PROXY ALL_PROXY http_proxy https_proxy all_proxy
```

可以用下面的命令测试网络连通性：

```bash
curl -I https://api.deepseek.com/anthropic
```

返回 `401`、`404` 或 `405` 通常也说明服务端可达。`Connection refused`、DNS 错误或超时才更像是网络或代理问题。

## 注意事项

这些脚本只是把 Claude Code 客户端请求路由到第三方服务商。它们不会让模型变成本地自托管。如果你使用云 API 服务商，模型推理仍然运行在对应服务商的基础设施上。
