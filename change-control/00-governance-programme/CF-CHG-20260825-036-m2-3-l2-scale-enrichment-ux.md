# CF-CHG-20260825-036 — M2.3 Production-Grade Data Operations, Scale Enrichment & Decision UX

**Status:** CLOSED / PASS — ACCEPTED PILOT/UAT SCOPE; NZ FIRST-PARTY L2 COURSE ENRICHMENT DEFERRED  
**Category:** 00-governance-programme  
**Initiated:** 25 August 2026 21:26 AEST (+10:00)  
**Scope expanded:** 25 August 2026 22:13 AEST (+10:00)  
**Closed:** 26 August 2026 12:23 AEST (+10:00)  
**Owner:** CourseFinder programme / Data Operations

## Outcome

M2.3 production-grade Data Operations is accepted in Pilot/UAT for the governed Layers 1–4 operating model:

`Layer 1 authoritative/regulatory → Layer 2 deterministic acquisition/extraction → Layer 3 AI-assisted Evidence interpretation → Layer 4 human resolution`.

Layer 4 remains terminal. Search/Publication remain downstream and broad Publication/Production cutover are not authorised by this closure.

## Accepted implementation

The accepted Pilot includes:

- AU CRICOS and NZ NZQA Layer 1 operational/recovery evidence with bounded retry/resume behaviour;
- shared Layer 2 source/profile/provider/Evidence/job foundations and representative AU scale/economics UAT;
- Firecrawl paid entitlement recorded as 5,000 pages/month with 250-page reserve and no silent paid fallback;
- governed Layer 3 provider profile, Vault-backed credential control, deterministic validation and zero-call/revalidation controls under CF-CHG-20260825-038;
- terminal Layer 4 queue and all six governed actions with Search refresh only after accepted canonical change;
- reusable Country / Provider / Course Onboarding under CF-CHG-20260825-037;
- source-precise Important Dates, bounded Refresh and Important Links;
- QILT/PRISMS decision context at their correct non-Course grains;
- Scholarship Selection with SOURCE FACT / DERIVED SCORE / MISSING-UNRESOLVED separation and no eligibility inference;
- role-specific M2.3 Data Operations guide;
- permanent deployed desktop/mobile regression across Data Quality, Layer 2, Course Detail, M2.3 Intelligence, Layer 3 provider control, Scholarship Selection, release notes, performance and screen-state persistence.

## Final accepted runtime

Pilot source:

`msinghbs-ai/Coursefinder-Pilot@260ed6a0d19b80ad666d74b90aa13e735e802a6a`

Visible release:

- PIM Admin `v2.15.5`;
- M2.3 Intelligence `v1.2`.

Evidence:

- Frontend Build `32917685085` — PASS;
- browser smoke — PASS;
- Deployed UAT `32917685022` — PASS;
- desktop job `98024710961` — PASS;
- mobile job `98024711090` — 29/29 PASS.

The preceding SHA `3feae676ea311531fe5dc24f55fc7a4321d2ad4e` is explicitly superseded because its Scholarship Selection launcher obstructed the mobile release-notes control. The repaired accepted SHA moves the launcher to the lower-right mobile safe zone; the unchanged release-notes test then passed.

## Layer 3 benchmark

The initial router-wide `openrouter/free` benchmark failed because routing was nondeterministic across free models. It was not accepted.

The profile was pinned to:

`nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free`

Benchmark run `a8e4b6c8-8a7b-45b4-a8df-c5a3bb4e8407` passed:

- provider semantic cases: 5/5;
- control cases: 13/13;
- observed cost: USD 0;
- maximum observed provider latency: 2.811 s;
- input/output tokens: 315 / 462.

The profile is therefore benchmark-approved and ACTIVE. The one-time benchmark execution path was retired after use.

## Onboarding acceptance

Representative rollback-only AU lifecycle UAT passed all nine stages through `production_promotion_ready`, invalid-transition rejection, immutable audit lineage, insufficient-rank/anon/private access denial and `canonical_fork=false`. Synthetic state was rolled back.

## NZ Layer 2 deferral

NZ authoritative Layer 1 is accepted. A dedicated NZ first-party Layer 2 Course enrichment source/profile is **not currently configured**.

That expansion is explicitly **DEFERRED** to a future NZ source-qualification/onboarding scope. The deferral does not create an M2.3 blocker because the shared Layer 2 platform, Layer 1 NZ authority and onboarding framework are accepted and the absent NZ source has not been represented as implemented.

## Security / performance

Final Security Advisor posture: INFO-only; no WARN/ERROR.

Final Performance Advisor posture: INFO-only. Existing unindexed-FK, unused-index and Auth connection-strategy notices remain backlog and are not M2.3 acceptance-level regressions. The new Layer 3 benchmark-job profile FK received a covering index before closure.

## Rollback / reversion boundary

- Browser/UI regressions: revert the relevant Pilot source commit and redeploy through the governed build/UAT path.
- Layer 3 provider risk: immediately pause the model profile; credentials remain server-side/Vault-backed.
- Database contract changes: use forward corrective migrations; do not mutate historical migration files after deployment.
- Layer 4 authority and Search signalling must not be bypassed during rollback.

## Acceptance

**CLOSED / PASS for accepted M2.3 Pilot/UAT scope, with NZ first-party Layer 2 Course enrichment explicitly DEFERRED.**

M2.4 is now unblocked but remains a separate optimisation/regression/residual-risk gate. Production establishment, broad Publication and Zoho cutover remain later authorised work.

## Commercial/time boundary

Technical execution does not create billable-time entries. The maintained engagement-time record remains authoritative.
