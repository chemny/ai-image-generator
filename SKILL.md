---
name: ai-image-generator
description: Use this skill whenever the user wants to generate, create, edit, or restyle an AI image through a configured Nano Banana-compatible API or OpenAI GPT Image-compatible API. Direct mode sends the user's prompt directly to the model. Pro mode only checks whether the user's prompt has the basic elements needed for generation, asks for missing information, then sends the completed user-approved prompt to the model.
version: 0.4.0
---

# AI Image Generator

Use this skill as a simple image generation bridge.

There are only two modes:

1. **Direct mode**: send the user's prompt or keywords directly to the selected image model.
2. **Pro mode**: check whether the user's prompt has enough basic generation information. If something important is missing, ask the user to fill it in. After the user confirms the missing information, send the completed prompt to the model.

Do not rewrite, optimize, stylize, expand, or re-rank the user's prompt unless the user explicitly asks you to write final copy. Do not use a case library or prompt examples to transform the user's intent.

## Direct Mode

Use Direct mode by default.

The final prompt is the user's original input:

```text
[user prompt or keywords]
```

Do not add output form, style, composition, quality, text, brand, safety, or negative prompt constraints in Direct mode. Provider parameters such as aspect ratio, image size, number of images, or input image path may still be passed as API parameters.

## Pro Mode

Use Pro mode only when the user asks for:

- Pro mode
- prompt checking
- help completing a prompt
- guidance before generation
- "帮我看看提示词是否完整"
- "缺什么你问我"
- "先帮我确认信息再生成"

Pro mode is not prompt optimization. It is a missing-information guide.

### Basic Elements To Check

Check whether the user's prompt contains enough information for generation:

- `subject`: what should appear in the image.
- `purpose`: what the image will be used for, if relevant.
- `output_type`: poster, cover, product photo, avatar, illustration, wallpaper, etc.
- `aspect_ratio_or_size`: ratio or size, if the target platform matters.
- `style_or_mood`: visual style, mood, realism level, or brand mood, if the user cares.
- `visible_text`: exact text to appear, or "no text", if the image may include text.
- `reference_image`: whether an input image should be used, and what must be preserved.
- `provider`: only when the user cares or multiple configured providers are available.

Only ask for missing items that materially affect generation. If the user clearly does not care, do not ask.

### Pro Interaction

When information is missing, ask concise questions before generation:

```text
我先补齐几个会影响生成结果的信息：
1. 图片比例/尺寸要用什么？如果你不指定，我按 [default]。
2. 图片里是否需要出现文字？如果需要，请给 exact text。
3. 是否有参考图，或者需要保持某个主体不变？
```

After the user answers, create a completed prompt that combines:

- the user's original wording,
- the user's answers to missing questions,
- no extra creative rewriting.

Then generate the image.

## Helper Script

Use this helper to inspect missing prompt elements:

```bash
bash scripts/build-prompt-brief.sh --query "<user prompt>"
```

The helper returns:

- inferred image type,
- likely aspect ratio,
- detected prompt elements,
- missing elements,
- questions to ask,
- Direct prompt instruction,
- Pro completion instruction.

## Image Generation

Generate through Nano Banana-compatible providers:

```bash
bash scripts/generate-image.sh \
  --provider nano-banana \
  --prompt "<user or completed prompt>" \
  --aspect-ratio 1:1 \
  --output-dir ./outputs
```

Generate through OpenAI GPT Image-compatible providers:

```bash
bash scripts/generate-image.sh \
  --provider openai \
  --prompt "<user or completed prompt>" \
  --size 1024x1024 \
  --output-dir ./outputs
```

For image-to-image, pass reference images:

```bash
bash scripts/generate-image.sh \
  --provider nano-banana \
  --input-image /absolute/path/reference.png \
  --prompt "<edit instruction>" \
  --aspect-ratio 1:1 \
  --output-dir ./outputs
```

## Configuration

Each user configures their own API keys and URLs in `.env`.

Nano Banana-compatible provider:

```bash
NANO_BANANA_API_URL="https://your-provider.example/v1beta/models/your-model:generateContent"
NANO_BANANA_API_KEY="your_api_key_here"
```

OpenAI GPT Image-compatible provider:

```bash
OPENAI_IMAGE_API_KEY="your_openai_or_proxy_key_here"
OPENAI_IMAGE_MODEL="gpt-image-1.5"
OPENAI_IMAGE_GENERATE_URL="https://api.openai.com/v1/images/generations"
OPENAI_IMAGE_EDIT_URL="https://api.openai.com/v1/images/edits"
```

Validate configuration:

```bash
bash scripts/check-config.sh
```

## Output Handling

After generation, return:

- generated image path(s),
- provider used,
- aspect ratio or size,
- prompt sent to the model,
- raw JSON path for debugging.

If the environment supports local image rendering, show the image:

```markdown
![generated image](/absolute/path/output.png)
```

## Troubleshooting

- Missing API key: run `bash scripts/check-config.sh`.
- Missing `jq`: install it first, for example `brew install jq`.
- Provider returns no image: inspect the saved raw JSON response.
- OpenAI model mismatch: set `OPENAI_IMAGE_MODEL` to the model supported by the user's account or proxy.
