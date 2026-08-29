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
