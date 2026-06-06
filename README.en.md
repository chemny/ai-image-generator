# AI Image Generator

Send user image prompts directly to a configured image API. Other skills can use this as a shared image generation component.

[中文](./README.md) | English

## What It Does

AI Image Generator is a single-skill repository for remote image generation.

- **Direct mode**: send the user's prompt or keywords directly to the model.
- **Pro mode**: check whether the prompt has the basic elements needed for generation, ask for missing information, then send the user-approved prompt to the model.
- **Reusable component**: other skills can call one script and receive a stable JSON result.
- **Size resolver**: if the user does not specify dimensions, known platform keywords can fill API size/ratio parameters.
- Supports GPT-image2 through OpenAI-compatible proxies such as Yunwu.
- Supports Nano Banana-compatible APIs.
- Supports SiliconFlow Qwen Image.
- Supports OpenAI GPT Image-compatible APIs.
- Supports image-to-image with reference images.

The skill does not rewrite prompts, imitate prompt examples, or run case-library optimization.

Size resolution does not rewrite prompts. It only fills API parameters.

## Who Is This For?

Use this skill if you want:

- a simple image generation skill connected to your own API key,
- direct prompt-to-image behavior by default,
- optional guidance when a prompt is missing important details.

It is not intended to be a prompt marketplace or an automatic prompt optimization system.

## Install

This is a single-skill repository. The repository root is the skill root.

Required shape:

```text
ai-image-generator/
└── SKILL.md
```

### 1. Clone

```bash
git clone https://github.com/<owner>/ai-image-generator.git
```

### 2. Put It In Your Skills Directory

Copy or symlink the repository into your agent's skills directory, for example:

```text
~/.agents/skills/ai-image-generator
~/.codex/skills/ai-image-generator
~/.claude/skills/ai-image-generator
```

OpenClaw users should use their configured skills directory.

### 3. Start A Fresh Agent Session

Many agents read `SKILL.md` when a new session starts. Open a fresh session after installation.

### 4. Verify

Ask your agent:

```text
Use ai-image-generator to generate a square image of a ceramic coffee cup on a clean studio background.
```

## Configure

Create `.env`:

```bash
cp .env.example .env
```

Nano Banana-compatible provider:

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

OpenAI GPT Image-compatible provider:

```bash
OPENAI_IMAGE_API_KEY="your_openai_or_proxy_key_here"
OPENAI_IMAGE_MODEL="gpt-image-1.5"
OPENAI_IMAGE_GENERATE_URL="https://api.openai.com/v1/images/generations"
OPENAI_IMAGE_EDIT_URL="https://api.openai.com/v1/images/edits"
```

Do not commit `.env`.

## Usage

Direct generation:

```bash
bash scripts/generate-image.sh \
  --provider auto \
  --prompt "Chanel Qixi perfume gift box poster, keep the brand logo, premium French elegance" \
  --aspect-ratio 3:4 \
  --output-dir ./outputs
```

Reusable component call from another skill:

```bash
bash /absolute/path/to/ai-image-generator/scripts/generate-image.sh \
  --provider auto \
  --prompt "$USER_PROMPT" \
  --output-dir "$OUTPUT_DIR" \
  --output-prefix "$ASSET_ID"
```

Resolve size without calling an image API:

```bash
bash scripts/resolve-image-spec.sh \
  --query "Generate a WeChat Official Account main cover about AI image models"
```

Size priority:

```text
explicit user size/aspect ratio
matched platform/use-case spec
provider/script default
```

Pro prompt check:

```bash
bash scripts/build-prompt-brief.sh \
  --query "Make a poster for a summer coffee campaign"
```

Image-to-image:

```bash
bash scripts/generate-image.sh \
  --provider nano-banana \
  --input-image ./reference.png \
  --prompt "Use this product image to create a clean e-commerce main image" \
  --aspect-ratio 1:1 \
  --output-dir ./outputs
```

Supported provider values:

```text
auto
gpt-image2
nano-banana
siliconflow-qwen-image
openai
```

Check configuration:

```bash
bash scripts/check-config.sh
```

## Common Size Defaults

The machine-readable table is [`references/platform-image-specs.json`](./references/platform-image-specs.json).

Examples:

- WeChat main cover: `2.35:1`, `1800x766`; provider fallback ratio `21:9`.
- WeChat body image: `16:9`, `1920x1080`.
- Xiaohongshu cover/content card: `3:4`, `1080x1440`.
- Douyin cover: `9:16`, `1080x1920`.
- PPT cover: `16:9`, `1920x1080`.
- Mobile wallpaper: `9:16`, `1080x1920`.
- E-commerce main image and avatar: `1:1`.

## Dependencies

- `bash`
- `curl`
- `jq`
- `base64`

On macOS:

```bash
brew install jq
```

## Platform Compatibility

Designed to be portable across Codex, Claude Code, and OpenClaw.

Current pre-publish status:

- Codex: tested by local script checks.
- Claude Code: not tested in this environment.
- OpenClaw: not tested in this environment.

## Repository Structure

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

Generated outputs and local environment files are excluded by `.gitignore`.

## License

MIT. See [`LICENSE`](./LICENSE).
