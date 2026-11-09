# Direct KBE Course link Skill and sidebar prompt — delivery

Date: 30 October 2026
Status: ready to install and use; no Kimi Work required

## Deliverables

- Focused Skill: `cf-layer4-course-link-kbe`
- Canonical source: `docs/platform/skills/cf-layer4-course-link-kbe/SKILL.md`
- Canonical source commit: `13c830001ee5f903f54af7aed12456d3ba553bf9`
- Package: `cf-layer4-course-link-kbe.skill`
- Package size: 3,069 bytes
- Package SHA-256: `8a70d8965ec2ad293242a2cec70794c00e6845fbe34c0f4ffa9299b5f7b5656c`

The existing `cf-layer4-triage` v5 Skill is unchanged. The new Skill is deliberately limited to Course link so the sidebar does not load the full 17-kind workflow.

## Use directly on the web page

1. Open the authenticated **Platform Admin → Data pipeline → Layer 4 Review** tab in Chrome or Edge.
2. Open the Kimi Browser Extension sidebar and sign in with the Kimi account that has the Skill installed.
3. Type `/` in the sidebar input and select `cf-layer4-course-link-kbe`.
4. Paste and send:

```text
layer4-course-links

Use the current Platform Admin tab. Start now with a short preflight, then reconcile Course link By kind across universities. Prove the first saved decision, then continue oldest first, one item at a time. Use stored evidence only. Process no other pills and use no SQL, AI re-checks, Firecrawl or new source acquisition. Keep checkpoints in this sidebar chat and report only submitted, verified outcomes. Leave unsupported items pending with an owner and next action.
```

Do not enable or configure **Local agent remote control** for this workflow. The sidebar uses the current tab and its existing authenticated browser session directly.

## What the Skill does

- Opens **By kind → Course link** and avoids unrelated queue scans.
- Uses only the existing Keep/Use-new/Enter-another-address choices.
- Proves the first Course link write before continuing; earlier fee or scholarship qualification is not reused.
- Processes stable refs oldest first, one item at a time, and verifies each ref leaves **Waiting for a person**.
- Preserves manual bindings and exact course/study-level identity rules.
- Uses stored evidence only and leaves inadequate or conflicting items pending.
- Keeps compact checkpoints in the current sidebar chat every 10 decisions and every 20 reviews without a decision.
- Reports actual decisions, real page changes, downstream reads, exceptions and new/re-raised items separately.

A checkpoint is resumable only while it remains visible in the current sidebar chat. After session loss, start a new batch from current queue state rather than claiming a portable resume.

## Validation

- Skill validation: passed.
- Skill name: 25 lowercase/hyphen characters, satisfying the current maximum-length rule.
- Packaged entries: exactly `cf-layer4-course-link-kbe/SKILL.md`.
- ZIP integrity: passed (`testzip` returned no bad entry).
- Packaged source equals local canonical source: passed.
- Local/canonical Git blob SHA-1: `0329d39ffaf230c26554a11fb1d89203cb371618` (exact match).
- Source length: 6,917 bytes, 90 lines.
- No scripts, external references, helper files or local-agent dependencies.

No live Platform Admin decision was submitted while building or validating this package. First-use write qualification remains mandatory.

## Official product basis

- The Browser Extension introduction distinguishes direct **Browser sidebar** use from remote control by a local Agent: https://www.kimi.ai/help/kimi-webbridge/kimi-webbridge-introduction
- The how-it-works article shows the sidebar input with `/` for Skills and describes operation on the current signed-in browser page: https://www.kimi.ai/help/kimi-webbridge/kimi-webbridge-how-it-works
- The Skills guide confirms `/` selection and automatic relevance-based invocation: https://www.kimi.ai/help/plugins-and-skills/use-skills-in-agent
- The custom-Skills FAQ gives the 25-character naming limit: https://www.kimi.ai/help/plugins-and-skills/create-custom-skills-faq
