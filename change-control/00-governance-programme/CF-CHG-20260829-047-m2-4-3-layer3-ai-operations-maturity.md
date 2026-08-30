# CF-CHG-20260829-047 — M2.4.3 Layer 3 AI Operations Maturity

**Status:** ACTIVE  
**Category:** 00-governance-programme  
**Initiated:** 29 August 2026  
**Origin chat/workstream:** M2.4.3 — Layer 3 AI Operations Maturity — Continue After A15 Closure  
**Owner:** M2.4.3 workstream  
**Change class:** AI operations / data contract / security / UI / telemetry / UAT / documentation

## Trigger

A15 Institute International Contact Intelligence is CLOSED / PASS under `CF-CHG-20260829-046`. Its closure does not close M2.4.3. The remaining Layer 3 AI Operations Maturity gates must now be completed against repository and deployed Pilot truth.

## Accepted starting baseline

- accepted Pilot: `f6741a0cc29c5fea236e85b9042f8079762c6993`;
- A15 final acceptance: `33251745111`, 17 permanent suites, 48/48 desktop + 48/48 mobile PASS;
- A15 functional contact freeze: `f9e4e530462b49cf5a83ad8e0d5137631255028a`;
- Layer 3 `openrouter-free-router-v1`: benchmarked PASS for the accepted M2.3 semantic task set;
- Layer 3 `openrouter-source-pattern-v1`: enabled but PAUSED because its source-pattern quality benchmark is not passing;
- accepted source-pattern threshold remains all governed provider cases + all controls + exact configured model + cost ceiling; the threshold must not be weakened merely to obtain PASS;
- accepted production Layer 3 interpretations at initiation: 0.

## Current blocker

The latest source-pattern profile is pinned to `openai/gpt-oss-20b:free`, which returned aggregator 404 for all benchmark cases. The best prior pinned Nemotron run passed 3/4 real-provider cases and 3/3 controls; Massey returned malformed/empty structured output. This is a model/profile reliability blocker, not authority to lower the quality gate.

## Scope

M2.4.3 will mature the existing Layer 3 foundation so that it:

1. selects governed Layer 2 Evidence deterministically for an eligible entity/task;
2. preserves explicit zero-call paths when a fresh interpretation or deterministic outcome makes an AI call unnecessary;
3. pins model/profile/prompt/validator versions and rejects unqualified or paused profiles;
4. records complete execution provenance including Evidence hash, model/provider, prompt profile, response model, calls/attempts, tokens, latency, cost, retries/fallback and outcome;
5. defines bounded retry and governed fallback semantics without hiding failures;
6. proves replay, revalidation, idempotency and concurrency behaviour;
7. enforces model-quality and confidence thresholds without accepting low-confidence output silently;
8. routes ambiguous, low-confidence, invalid or otherwise unresolved results to Layer 4 with the full decision package;
9. gives operators a primary Layer 3 workspace showing Evidence → model/profile → result → confidence → provenance → human-review state;
10. keeps credentials and private Evidence behind accepted service/authenticated boundaries;
11. maintains A14 telemetry and permanent deployed UAT;
12. progresses targeted → bounded integration desktop/mobile → one final acceptance candidate.

## Authority boundaries

- Layer 1 remains canonical Provider/Course identity and regulatory/source authority.
- Layer 2 remains deterministic acquisition/extraction and Evidence authority.
- Layer 3 is Evidence interpretation only. It must not directly rewrite Layer 1 or accepted Layer 2 observations and must not directly mutate Search/Publication.
- Layer 4 remains terminal human resolution for ambiguous/low-confidence/validated candidate decisions.
- A15 contact Evidence may be consumed by Layer 3 only as governed Provider context; it remains Layer 2 source truth.
- Search/Public Website and Zoho admission remain separate governed consumer decisions.

## Preserved accepted behaviour

A10–A15 behaviour remains protected, including paged/tablet-safe filters, contextual QILT/PRISMS/Scholarship presentation, normal Layer 2 operator routing, Direct HTTP → Firecrawl → governed fallback → Evidence, screenshot/HTML Evidence, wider Course workspace, Provider International contacts, granularity/authority labels, Evidence security and A14 telemetry.

## Validation plan

1. Targeted database/Edge/UI contract tests for Layer 3 only.
2. Bounded integration desktop/mobile including immediate Layer 2 Evidence, Layer 4 review, Evidence and security dependencies.
3. Security and Performance Advisor reconciliation.
4. One final deployed acceptance candidate after source freeze.
5. Formal M2.4.3 CLOSE / PASS only when the complete operating contract is proven. M2.4.4 must not start before that closure.

## Explicit non-blocking carry-forward

- VU/Otago/Wellington durable contact reconciliation across parser refresh;
- Firecrawl subscription cash-cost mapping;
- Layer 1 correction of stale/malformed Provider websites;
- A15 contact-quality regression metrics;
- Apollo licensed enrichment configuration;
- Zoho consumer admission.

## Rollback

Layer 3 changes must remain additive/reversible around existing Evidence, interpretation and Layer 4 review history. Rollback must pause the affected profile/route or restore the prior Edge/UI contract without deleting governed Evidence, benchmark history, interpretation provenance or Layer 4 history.


## Execution checkpoint — 30 August 2026

The source-pattern quality blocker was resolved without changing the accepted acceptance threshold.

Accepted requalification:
- benchmark run `089befcf-a2f2-42ec-ad03-7bfe02816e1b`;
- 4/4 governed real-provider cases PASS;
- 3/3 controls PASS;
- exact pinned model `nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free`;
- 8 actual provider calls, including one successful malformed-output retry;
- 4,454 input / 832 output tokens;
- USD 0 estimated provider cost.

The deployed Layer 3 operating contract now includes deterministic governed Evidence selection, benchmark-qualified profile execution, zero-call/replay/revalidation paths, attempt-level retry telemetry, explicit qualified fallback semantics, confidence fall-out to Layer 4, active-work concurrency dedupe, stale execution recovery and the operator Evidence→model→result→review chain.

First bounded integration evidence is retained as a failed gate:
- candidate `b6318bdcbc657b4be524ee58e5728c2b84f91687`;
- run `33254320472`;
- desktop FAIL / mobile skipped;
- 42 tests PASS / 2 tests FAIL;
- failures were stale checked-in assertions for the old benchmark worker version and old Layer 3 UI label;
- the new M2.4.3 permanent suite passed in that run.

Corrective source `3b43f0a8cb4d1758225b139a773b118be372be30` aligns the inherited assertions and repository migration filename with deployed runtime version `20260829130640`. No authority, benchmark threshold, Evidence security, model output acceptance rule or retry limit was weakened.

Status remains ACTIVE pending corrective targeted/integration and final acceptance.

## Final acceptance nomination — 30 August 2026

- Final bounded integration source: `ea6077e8e443a4a43adbf9f3285dac3dd3e631fd`.
- Integration run `33276423521`: **PASS**.
- Resolved tier: `integration`, 15 permanent suites.
- Desktop: **45/45 PASS**.
- Mobile: **45/45 PASS**.
- Frontend build `33276423532`: **PASS**.
- Final acceptance marker commit: `3a8a31310ea7147016374d6c818d08034ba0be64`.
- Final acceptance UAT run: `33284867253` — **QUEUED at handoff**.
- Final acceptance frontend build: `33284867261` — **QUEUED at handoff**.
- Do not create another acceptance candidate unless this exact run fails for a source/runtime defect requiring a corrective change.
- If `33284867253` resolves `acceptance` and both desktop/mobile PASS, reconcile advisors/runtime/heads, close CF-CHG-20260829-047, mark M2.4.3 CLOSED/PASS, update Master Project Plan / Running Build / DB Architecture / Admin-PIM decisions as required, then and only then assess M2.4.4.
- If it fails, retain the run as immutable evidence, diagnose the exact failing suite, correct only the defect/contract drift, rerun targeted then bounded integration as required before nominating a new acceptance candidate.
