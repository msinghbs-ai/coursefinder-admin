# M2.3 Current State

**Status:** ACTIVE / GO 5 TECHNICAL ACCEPTANCE PASS / FINAL GOVERNANCE CLASSIFICATION REMAINS  
**Updated:** 26 August 2026 11:16 AEST  
**Primary Change Controls:** CF-CHG-20260825-036, CF-CHG-20260825-037, CF-CHG-20260825-038

## Programme baseline

- M1: CLOSED / PASS / FROZEN.
- M2.1: CLOSED / PASS.
- M2.2: CLOSED / PASS for accepted Pilot scope.
- M2.3: technical acceptance PASS at Go 5 repaired runtime; final Change Control/register/Running Build classification remains.
- M2.4: NOT STARTED until that classification is written.
- broad Publication and Production cutover remain unauthorised.

## Accepted Go 5 deployed runtime

Pilot SHA `260ed6a0d19b80ad666d74b90aa13e735e802a6a`.

Visible release remains:

- PIM Admin `v2.15.5`;
- M2.3 Intelligence `v1.2`.

Acceptance evidence:

- Pilot Frontend Build `32917685085` — PASS;
- browser smoke — PASS;
- Deployed UAT `32917685022` — PASS;
- desktop `98024710961` — PASS;
- mobile `98024711090` — 29/29 PASS.

The prior SHA `3feae676ea311531fe5dc24f55fc7a4321d2ad4e` is superseded because its mobile run failed release-notes pointer interaction. The defect was real: the Scholarship Selection fixed launcher intercepted the top-right release pill on mobile. The repaired CSS moves the launcher to the lower-right safe zone; the same permanent UAT now passes without weakening tests.

## Layer 3 accepted provider state

Profile `openrouter-free-router-v1`:

- enabled: true;
- paused: false;
- validation: `benchmark_passed`;
- configured model: `nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free`;
- Vault credential configured and verified without exposing the secret to chat/governance.

Benchmark `a8e4b6c8-8a7b-45b4-a8df-c5a3bb4e8407`:

- provider semantic cases 5/5 PASS;
- controls 13/13 PASS;
- observed cost USD 0;
- maximum latency 2.811s;
- unchanged Evidence zero-call PASS;
- changed Evidence / expired interpretation / governed revalidation eligibility PASS;
- malformed/unsupported/unavailable-model rejection and operating ceilings PASS.

The earlier `openrouter/free` router-wide benchmark is retained as FAIL evidence because nondeterministic model routing caused a semantic failure. The pinned model is the accepted profile.

Temporary Go 5 benchmark execution scaffolding is retired. Source-controlled migrations retain benchmark/result lineage; the retired Edge trigger is JWT-protected and returns HTTP 410.

## Onboarding acceptance

CF-CHG-037 representative rollback-only UAT is PASS:

- existing AU source/profile/provider/course/Evidence linkage used;
- all nine stages traversed through `production_promotion_ready`;
- invalid transition rejection PASS;
- READY outcome semantics PASS;
- immutable actor/reason/UAT/Evidence lineage verified;
- curator, anon, direct private-table and private-helper denial PASS;
- shared schema preserved with `canonical_fork=false`;
- synthetic UAT state rolled back.

## Layer 1 / Layer 2 classification basis

- AU CRICOS primary Layer 1 is operational with bounded offset/resume and recovery evidence.
- NZ NZQA primary Layer 1 is operational with bounded offset/resume and successful recovery following failure bursts.
- AU Layer 2 Course/Scholarship acquisition has representative operational/recovery evidence across Federation, RMIT, UQ and Study Australia.
- Direct HTTP remains preferred when it satisfies Evidence requirements.
- Firecrawl remains bounded to the user-confirmed 5,000 pages/month entitlement with a 250-page safety reserve and no silent paid fallback.
- NZ first-party Layer 2 Course enrichment is not currently configured and should be classified explicitly DEFERRED to future NZ source qualification/onboarding rather than represented as PASS.

## Security / performance

- Security Advisor: INFO-only; no WARN/ERROR acceptance finding.
- Performance Advisor: INFO-only inherited backlog.
- The new Layer 3 benchmark-job profile foreign key has a covering index; no new unindexed-FK regression remains from Go 5.
- Browser roles continue to have no direct Vault/private-table authority.

## Exact next dependency order

1. Update CF-CHG-20260825-036, -037 and -038 to the Go 5 evidence and final PASS/DEFERRED classification.
2. Update Change Control REGISTER and current Running Build to `260ed6a0d19b80ad666d74b90aa13e735e802a6a`.
3. Close M2.3 as PASS for accepted Pilot/UAT scope with NZ first-party Layer 2 expansion explicitly DEFERRED, provided no newer parallel runtime introduces a regression.
4. Only then authorise/start M2.4 according to the current master plan.

## Handoff rule

Current GitHub, deployed Supabase/runtime and CI remain authoritative. Do not regress to `3feae676…` or the stale `openrouter/free` profile. Before ending any further M2.3 execution chat, keep RUNSHEET/CURRENT-STATE/NEXT-CHAT and applicable governance aligned to deployed truth.