# M2.3 Current State

**Status:** CLOSED / PASS — ACCEPTED PILOT/UAT SCOPE; NZ FIRST-PARTY L2 COURSE ENRICHMENT DEFERRED  
**Updated:** 26 August 2026 12:23 AEST  
**Primary Change Controls:** CF-CHG-20260825-036 CLOSED/PASS with NZ L2 deferral; CF-CHG-20260825-037 CLOSED/PASS; CF-CHG-20260825-038 CLOSED/PASS

## Programme baseline

- M1: CLOSED / PASS / FROZEN.
- M2.1: CLOSED / PASS.
- M2.2: CLOSED / PASS.
- M2.3: **CLOSED / PASS** for accepted Pilot/UAT scope.
- M2.4: PLANNED / UNBLOCKED / NOT STARTED.
- broad Publication and Production cutover remain unauthorised.

Current programme authority:

- Master Project Plan `docs/coursefinder-master-project-plan-v1.72.md`;
- Running Build `docs/coursefinder-running-build-v2.73.md`;
- Change Control Register updated to the same M2.3 closure state.

## Final accepted M2.3 runtime

Pilot SHA:

`260ed6a0d19b80ad666d74b90aa13e735e802a6a`

Visible release:

- PIM Admin `v2.15.5`;
- M2.3 Intelligence `v1.2`.

Evidence:

- Frontend Build `32917685085` — PASS;
- browser smoke — PASS;
- Deployed UAT `32917685022` — PASS;
- desktop `98024710961` — PASS;
- mobile `98024711090` — 29/29 PASS.

Do not regress to `3feae676ea311531fe5dc24f55fc7a4321d2ad4e`; it contained the real mobile Scholarship Selection/release-notes collision that was corrected in the accepted SHA.

## Layer 3 accepted state

Profile `openrouter-free-router-v1` is benchmark-approved and ACTIVE on:

`nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free`

- enabled: true;
- paused: false;
- validation: `benchmark_passed`;
- Vault credential configured/verified without exposing the secret to chat/governance.

Benchmark `a8e4b6c8-8a7b-45b4-a8df-c5a3bb4e8407` passed 5/5 provider semantic cases and 13/13 controls at USD 0 observed cost with 2.811 s maximum observed provider latency.

The earlier router-wide `openrouter/free` configuration failed quality acceptance and is not the accepted model state. Provider/model changes require governed revalidation/benchmark before resume.

## Layer 4

All six terminal actions passed rollback-only acceptance. Search refresh is downstream of successful accepted canonical change only. Reject creates no Search signal; More Evidence/Return L2/Return L3 create bounded refresh/revalidation work only.

## Onboarding

CF-CHG-037 is CLOSED/PASS. Representative rollback-only AU lifecycle UAT traversed all nine stages, rejected invalid transition, retained immutable audit lineage, denied insufficient-rank/anon/private access, linked existing source/profile/provider/course/Evidence records and recorded `canonical_fork=false`. Synthetic state was rolled back.

## Layer 1 / Layer 2

- AU CRICOS Layer 1: accepted operational/recovery evidence.
- NZ NZQA Layer 1: accepted operational/recovery evidence.
- shared Layer 2 platform: accepted.
- representative AU Layer 2 scale/economics/provider routing: accepted.
- Firecrawl: 5,000 pages/month with 250-page reserve and no silent paid fallback.
- NZ first-party Layer 2 Course enrichment: **DEFERRED** pending future NZ source qualification/onboarding.

The NZ deferral is not an M2.3 failure and must not be represented as implemented.

## Decision UX / operating surfaces

Accepted deployed surfaces include Data Quality, Layer 2 Operations, Layer 3, Layer 4, Refresh, Important Links, source-precise Important Dates, Onboarding, QILT/PRISMS decision context, Scholarship Selection and maintained PIM release notes.

Scholarship Selection preserves SOURCE FACT / DERIVED SCORE / MISSING-UNRESOLVED and forbids eligibility inference.

## Security / performance

- Security Advisor: INFO-only; no WARN/ERROR.
- Performance Advisor: INFO-only inherited backlog.
- browser roles have no direct Vault/private-table authority where prohibited.
- the Go 5 Layer 3 benchmark-job FK has a covering index.

## Closure boundary

M2.3 is complete. Do not reopen it merely to perform M2.4 optimisation or later NZ expansion.

M2.4 may begin under its own governed workstream and must preserve the accepted Layer authority model. Production establishment, broad Publication and Zoho cutover remain later gates.
