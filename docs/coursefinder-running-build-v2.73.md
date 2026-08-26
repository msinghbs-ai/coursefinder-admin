# CourseFinder Running Build v2.73

**Status:** M1 FROZEN / M2.1 CLOSED-PASS / M2.2 CLOSED-PASS / **M2.3 CLOSED-PASS — NZ L2 EXPANSION DEFERRED**  
**Date:** 26 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.72.md`  
**Master Project Plan:** `docs/coursefinder-master-project-plan-v1.72.md`  
**Change Controls:** `CF-CHG-20260825-036`, `CF-CHG-20260825-037`, `CF-CHG-20260825-038`

## Accepted Pilot runtime

Final M2.3 source:

`msinghbs-ai/Coursefinder-Pilot@260ed6a0d19b80ad666d74b90aa13e735e802a6a`

Visible browser release:

- PIM Admin `v2.15.5`;
- M2.3 Intelligence `v1.2`.

Acceptance evidence:

- Frontend Build `32917685085` — PASS;
- browser smoke — PASS;
- Deployed UAT `32917685022` — PASS;
- desktop job `98024710961` — PASS;
- mobile job `98024711090` — 29/29 PASS.

SHA `3feae676ea311531fe5dc24f55fc7a4321d2ad4e` is superseded because its Scholarship Selection launcher intercepted the mobile release-notes control. The accepted SHA contains the responsive placement fix and passes the unchanged mobile release-notes test.

## Layer 3

The Platform Admin credential workflow stores OpenRouter credentials in Supabase Vault through a JWT-protected rank-6 Edge control and never returns the secret to the browser.

The initial router-wide `openrouter/free` profile failed the quality benchmark and is not the accepted model configuration.

Accepted model:

`nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free`

Profile state:

- enabled: true;
- paused: false;
- validation: `benchmark_passed`;
- requests/minute: 20;
- requests/day: 50;
- max input/output: 12,000 / 1,200 tokens;
- retry ceiling: 1;
- timeout: 30 seconds;
- cost ceiling: USD 0.

Benchmark `a8e4b6c8-8a7b-45b4-a8df-c5a3bb4e8407` passed 5/5 provider semantic cases and 13/13 controls, with USD 0 observed cost and 2.811 s maximum observed provider latency. The one-time benchmark execution path has been retired.

## Layer 4

All six terminal actions are accepted: Approve, Edit and Approve, Reject, Request More Evidence, Return to Layer 2 and Return to Layer 3.

Search refresh signals are created only after successful accepted canonical change. Reject creates no Search signal; return/evidence actions create bounded refresh/revalidation work only.

## Onboarding

CF-CHG-20260825-037 is CLOSED/PASS. Rollback-only representative AU lifecycle UAT traversed all nine stages, rejected invalid transition, retained immutable audit lineage, denied insufficient-rank/anonymous/private access and proved `canonical_fork=false` while linking existing source/profile/provider/course/Evidence registries.

## Layer 1 / Layer 2

- AU CRICOS Layer 1: operational/recovery evidence accepted.
- NZ NZQA Layer 1: operational/recovery evidence accepted.
- shared Layer 2 platform: accepted.
- representative AU Layer 2 scale/economics and provider routing: accepted.
- Firecrawl: 5,000 pages/month, 250-page reserve, no silent paid fallback.
- NZ first-party Layer 2 Course enrichment: **DEFERRED** pending future NZ source qualification/onboarding.

## Decision intelligence / UX

Accepted deployed surfaces include Data Quality, Layer 2 Operations, governed Layer 3, terminal Layer 4, Refresh, Important Links, source-precise Important Dates, Onboarding, QILT/PRISMS decision context, Scholarship Selection and maintained PIM release notes.

Scholarship Selection keeps SOURCE FACT / DERIVED SCORE / MISSING-UNRESOLVED separate and does not infer student eligibility.

## Security / performance

- Security Advisor: INFO-only; no WARN/ERROR.
- Performance Advisor: INFO-only; remaining unindexed-FK/unused-index/Auth connection-strategy observations remain backlog.
- Browser roles retain no direct Vault grants.
- Elevated private helpers remain non-executable by anon/authenticated where intended.

## Gate state

- M1 — CLOSED / PASS / FROZEN;
- M2.1 — CLOSED / PASS;
- M2.2 — CLOSED / PASS;
- M2.3 — **CLOSED / PASS — NZ L2 EXPANSION DEFERRED**;
- CF-CHG-036 — CLOSED / PASS with NZ L2 deferral;
- CF-CHG-037 — CLOSED / PASS;
- CF-CHG-038 — CLOSED / PASS;
- M2.4 — PLANNED / UNBLOCKED / NOT STARTED;
- broad Publication — NOT AUTHORISED;
- Production cutover — NOT AUTHORISED.

## Next programme gate

M2.4 may now begin when authorised. It should focus on AI/Data Quality optimisation, provider/model monitoring, queue tuning, full-stack regression, evidence-based performance improvements, residual-risk closure and the pre-blackout checkpoint. It must preserve the accepted Layer authority model and must not silently absorb Production/Publication/Zoho scope.

## Commercial/time boundary

Technical execution does not create billable-time entries. The maintained engagement-time record remains authoritative.
