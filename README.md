# AI Image Generator

把用户输入的生图提示词直接交给配置好的图片 API。其他 skills 可以把它当作通用生图组件调用。

中文 | [English](./README.en.md)

## 它能做什么？

AI Image Generator 是一个「单 skill 单仓库」的远程生图工具。

- **Direct 模式**：把用户输入的提示词或关键词直接交给模型。
- **Pro 模式**：检查提示词是否缺少基础生成信息，向用户追问缺项，然后把用户确认后的提示词交给模型。
- **通用组件**：其他 skills 可以调用同一个脚本，并拿到稳定 JSON 结果。
- **尺寸解析**：用户没指定尺寸时，可以根据常见平台关键词补齐 API 尺寸/比例参数。
- 支持通过云雾等 OpenAI 兼容代理调用 GPT-image2。
- 支持 Nano Banana 兼容接口。
- 支持 SiliconFlow Qwen Image。
- 支持 OpenAI GPT Image 兼容接口。
- 支持带参考图的 image-to-image。

这个 skill 不会自动改写提示词，不会仿写案例，也不会做案例库优化。

尺寸解析不是 prompt 改写，只会补 API 参数。

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
IMAGE_PROVIDER="auto"

GPT_IMAGE2_BASE_URL="https://yunwu.ai"
GPT_IMAGE2_MODEL="gpt-image-2-all"
GPT_IMAGE2_API_KEY="your_api_key_here"

NANO_BANANA_API_URL="https://your-provider.example/v1beta/models/your-model:generateContent"
NANO_BANANA_API_KEY="your_api_key_here"

SILICONFLOW_BASE_URL="https://api.siliconflow.cn/v1/images/generations"
SILICONFLOW_MODEL="Qwen/Qwen-Image"
SILICONFLOW_API_KEY="your_api_key_here"
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
  --provider auto \
  --prompt "香奈儿七夕香水礼盒海报，保留品牌logo，高级法式风格" \
  --aspect-ratio 3:4 \
  --output-dir ./outputs
```

其他 skill 调用这个通用组件：

```bash
bash /absolute/path/to/ai-image-generator/scripts/generate-image.sh \
  --provider auto \
  --prompt "$USER_PROMPT" \
  --output-dir "$OUTPUT_DIR" \
  --output-prefix "$ASSET_ID"
```

只解析尺寸，不调用生图 API：

```bash
bash scripts/resolve-image-spec.sh \
  --query "生成一张微信公众号头图，主题是 AI 生图模型配置"
```

尺寸优先级：

```text
用户显式指定尺寸/比例
匹配平台/用途规格表
provider 或脚本默认值
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

支持的 provider：

```text
auto
gpt-image2
nano-banana
siliconflow-qwen-image
openai
```

检查配置：

```bash
bash scripts/check-config.sh
```

## 常用尺寸默认值

机器可读规格表在 [`references/platform-image-specs.json`](./references/platform-image-specs.json)。

示例：

- 微信公众号头图：`2.35:1`，`1800x766`；provider 不支持时用 `21:9`。
- 微信公众号正文配图：`16:9`，`1920x1080`。
- 小红书封面/配图：`3:4`，`1080x1440`。
- 抖音封面：`9:16`，`1080x1920`。
- PPT 封面：`16:9`，`1920x1080`。
- 手机壁纸：`9:16`，`1080x1920`。
- 电商主图和头像：`1:1`。

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
├── README.en.md
├── LICENSE
├── .env.example
├── references/
├── scripts/
├── ACCEPTANCE.md
├── CHANGELOG.md
└── RELEASE_CHECKLIST.md
```

生成图片和本地环境变量已经通过 `.gitignore` 排除。

## 许可证

MIT。见 [`LICENSE`](./LICENSE)。
