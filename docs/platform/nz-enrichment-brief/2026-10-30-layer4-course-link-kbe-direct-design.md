# Direct KBE Course link Skill — design

Date: 30 October 2026
Status: approved design for implementation in this mandate

## Decision

Create a focused `cf-layer4-course-link-kbe` Skill for the Kimi Browser Extension sidebar. Leave `cf-layer4-triage` v5 unchanged.

The new Skill will handle only **Data pipeline → Layer 4 Review → By kind → Course link** on the current authenticated Platform Admin tab. It will not require Kimi Work, a local-agent remote-control connection, SQL, GitHub access, helper files or a separate checkpoint document.

## Why a separate Skill

- The user's current task is Course link only; loading all 17 kinds adds irrelevant instructions.
- The official Kimi Browser Extension documentation supports direct sidebar chat on the current page and shows `/` for Skills in the sidebar input.
- A focused Skill matches the official Skills guidance that a Skill should do one thing well.
- Direct sidebar checkpoints will be concise chat checkpoints. A lost sidebar session is not a portable resume; a later run starts from current queue state without repeating refs that already left waiting.

## Preserved v5 controls

- First Course link decision verified before continuing; previous fee/scholarship qualification does not qualify this route.
- Existing choices only: Keep the page we hold, Use the new page, Enter another address.
- Exact course/study-level identity and official stored evidence required; manual bindings never overwritten.
- One item at a time, stable refs, oldest first, no select-all or generic bulk decision.
- Stored evidence only; no AI re-checks, Firecrawl, paid reads or new source acquisition.
- Verify each ref leaves Waiting for a person; do not open the failing Decided view or request SQL.
- Chat checkpoints every 10 decisions and every 20 reviews without a decision.
- Unsupported items remain pending with owner and next action; no forced zero.
- Actual decisions, page changes, downstream reads, exceptions and new/re-raised work reported separately.

## Direct-sidebar optimisations

- No long planning phase and no unrelated queue scan.
- Read page text/controls first; use a screenshot only when page state or an error is unclear.
- Refresh only when needed to verify a write and once at final reconciliation.
- Keep the batch narrative in the current sidebar chat rather than creating local files.

## Official product sources

- Kimi Browser Extension introduction: https://www.kimi.ai/help/kimi-webbridge/kimi-webbridge-introduction
- How Kimi Browser Extension Works: https://www.kimi.ai/help/kimi-webbridge/kimi-webbridge-how-it-works
- Using Skills in Agent Mode: https://www.kimi.ai/help/plugins-and-skills/use-skills-in-agent

## Deliverables

- Installable `cf-layer4-course-link-kbe.skill` package.
- Canonical `SKILL.md` in the admin repository.
- Short copy-paste sidebar prompt using `/` Skill selection and `layer4-course-links`.
- Validation, package integrity and canonical-source verification recorded in the delivery document.
