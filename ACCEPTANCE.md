# Acceptance Checklist

## Completed

- Skill structure is complete for the simplified release: `SKILL.md`, `README.md`, `README.zh.md`, `LICENSE`, scripts, and release checklist.
- Direct mode sends the user's prompt directly to the model.
- Pro mode is simplified to missing-information guidance only.
- Prompt rewriting, prompt option generation, case-library selection, and rule-based prompt optimization are not part of the active release workflow.
- Nano Banana-compatible provider has passed real API generation tests.
- OpenAI GPT Image-compatible provider is implemented.
- Release ignore rules exclude `.env`, local env variants, generated outputs, response JSON files, local workflow test results, old prompt-case data, evals, and old prompt-rule references.

## Not Fully Verified

- OpenAI GPT Image-compatible provider is implemented but not real-API tested because no API key is available.
- Cross-agent installation testing is not done yet for Claude Code, Open Codex, and OpenClaw.

## Test Policy

OpenAI provider must remain marked as unverified until a real successful API call is completed with a valid key.
