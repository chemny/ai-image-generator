# Release Checklist

Use this checklist before publishing the skill to GitHub.

## Required

- Confirm `.env` is not committed.
- Confirm generated files under `outputs/` are not committed.
- Confirm local workflow artifacts such as `WORKFLOW_TEST_RESULTS.md` are not committed.
- Run script syntax checks:

```bash
bash -n scripts/build-prompt-brief.sh
bash -n scripts/generate-image.sh
bash -n scripts/check-config.sh
```

- Run config check:

```bash
bash scripts/check-config.sh
```

- Review `README.md`, `SKILL.md`, and `.env.example`.

## Recommended

- Add a repository `LICENSE` file before public release.
- Verify install behavior in Claude Code, Open Codex, and OpenClaw.
- Keep OpenAI GPT Image provider marked as unverified until a real API call succeeds with a valid key.
- Confirm old prompt-case data, evals, and prompt-rule references are not included unless intentionally re-enabled.
