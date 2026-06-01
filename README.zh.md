# AI Image Generator

把用户输入的生图提示词直接交给配置好的图片 API。Pro 模式只做基础缺项检查。

中文 | [English](./README.md)

## 它能做什么？

AI Image Generator 是一个「单 skill 单仓库」的远程生图工具。

- **Direct 模式**：把用户输入的提示词或关键词直接交给模型。
- **Pro 模式**：检查提示词是否缺少基础生成信息，向用户追问缺项，然后把用户确认后的提示词交给模型。
- 支持 Nano Banana 兼容接口。
- 支持 OpenAI GPT Image 兼容接口。
- 支持带参考图的 image-to-image。

这个 skill 不会自动改写提示词，不会仿写案例，也不会做案例库优化。

## 适合谁？

适合这些场景：

- 你想把自己的生图 API 接到 Agent 里；
- 你希望默认就是「用户说什么，模型生成什么」；
- 你只需要在提示词信息不完整时，让 Agent 帮你追问补齐。

它不是 prompt 市场，也不是自动提示词优化系统。

## 怎么安装？

这是一个「单 skill 单仓库」。仓库根目录就是 skill 根目录。

必须满足这个结构：

```text
ai-image-generator/
└── SKILL.md
```

### 1. 克隆仓库

```bash
git clone https://github.com/<owner>/ai-image-generator.git
```

### 2. 放到你的 skills 目录

把仓库复制或软链接到你的 Agent skills 目录，例如：

```text
~/.agents/skills/ai-image-generator
~/.codex/skills/ai-image-generator
~/.claude/skills/ai-image-generator
```

OpenClaw 用户请使用自己配置的 skills 目录。

### 3. 开一个新会话

很多 Agent 会在新会话启动时读取 `SKILL.md`。安装后建议重新开一个会话。

### 4. 验证

对 Agent 说：

```text
使用 ai-image-generator 生成一张方形图片：干净摄影棚背景里的陶瓷咖啡杯。
```

## 配置

创建 `.env`：

```bash
cp .env.example .env
```

Nano Banana 兼容接口：

```bash
NANO_BANANA_API_URL="https://your-provider.example/v1beta/models/your-model:generateContent"
NANO_BANANA_API_KEY="your_api_key_here"
```

OpenAI GPT Image 兼容接口：

```bash
OPENAI_IMAGE_API_KEY="your_openai_or_proxy_key_here"
OPENAI_IMAGE_MODEL="gpt-image-1.5"
OPENAI_IMAGE_GENERATE_URL="https://api.openai.com/v1/images/generations"
OPENAI_IMAGE_EDIT_URL="https://api.openai.com/v1/images/edits"
```

不要提交 `.env`。

## 使用方式

Direct 直接生成：

```bash
bash scripts/generate-image.sh \
  --provider nano-banana \
  --prompt "香奈儿七夕香水礼盒海报，保留品牌logo，高级法式风格" \
  --aspect-ratio 3:4 \
  --output-dir ./outputs
```

Pro 缺项检查：

```bash
bash scripts/build-prompt-brief.sh \
  --query "给夏季咖啡活动做一张海报"
```

参考图生图：

```bash
bash scripts/generate-image.sh \
  --provider nano-banana \
  --input-image ./reference.png \
  --prompt "用这张产品图做一张干净的电商主图" \
  --aspect-ratio 1:1 \
  --output-dir ./outputs
```

检查配置：

```bash
bash scripts/check-config.sh
```

## 依赖

- `bash`
- `curl`
- `jq`
- `base64`

macOS 安装 `jq`：

```bash
brew install jq
```

## 平台兼容性

设计上尽量兼容 Codex、Claude Code 和 OpenClaw。

当前发布前状态：

- Codex：已做本地脚本检查。
- Claude Code：当前环境未测试。
- OpenClaw：当前环境未测试。

## 仓库结构

```text
.
├── SKILL.md
├── README.md
├── README.zh.md
├── LICENSE
├── .env.example
├── scripts/
├── ACCEPTANCE.md
├── CHANGELOG.md
└── RELEASE_CHECKLIST.md
```

生成图片和本地环境变量已经通过 `.gitignore` 排除。

## 许可证

MIT。见 [`LICENSE`](./LICENSE)。
