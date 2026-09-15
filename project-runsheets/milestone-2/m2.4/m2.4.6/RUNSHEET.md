# M2.4.6 RUNSHEET — Production Operations Model

**Status:** ACTIVE — ADMISSION-FIRST EXECUTION  
**Opened:** 2026-09-15 AEST  
**Predecessor:** M2.4.5 CLOSED / PASS / FROZEN  
**Successor:** M2.4.7 Controlled Operational Scale  
**Programme authority:** `../M2.4.6-M2.4.9-OPERATIONS-PLAN.md`  
**Execution priority:** `EXECUTION-PRIORITY.md`

## Accepted predecessor baseline

- Pilot main: `e62c01cadaf43efa8c3d8ea57625c23874d1b010`.
- Visible accepted release: v2.15.79 / package 0.1.6.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Production Supabase: not provisioned.
- CF-093: CLOSED / PASS / HISTORICAL ONLY.
- CF-245: CLOSED / PASS; operational telemetry and Enrichment Operations reporting are accepted baseline capabilities.
- Final M2.4.5 acceptance: dedicated CF-245 UAT `34926246733`, generic targeted UAT `34926246675`, build/smoke `34926246673`, Cloudflare deployment all PASS.

## M2.4.6 objective

Define and prove the minimum practical day-to-day operating model required to safely keep admitting qualified data and handing it to governed consumers. Do not make optional operational improvements prerequisites for admission or website handover.

## Permanent stop rule

A newly discovered issue blocks M2.4.6 only when it directly prevents safe deterministic admission, required security/identity/Layer authority, Search/API correctness, or bounded recovery from an active failure. Otherwise record it for the owning later gate and continue.

## Gates

- [x] Gate A — predecessor baseline reconciled and frozen.
- [x] Gate B — dispatcher/wave operating contract materially reconciled: server-owned/rank-gated wave dispatch, qualified scope checks, wave clamping, per-profile serialization, scheduled continuation and explicit NZ Course block are present. Remaining improvements must pass the stop rule before becoming blockers.
- [ ] Gate C — minimum failure/recovery contract: only fixes required to prevent duplicate/unsafe execution; optional retry/reuse improvements may defer.
- [ ] Gate D — confirm existing provider quota/cost/concurrency stop controls are sufficient for bounded operation; do not tune without evidence.
- [x] Gate E — accepted CF-245 observability retained; admission and consumer deltas are measurable.
- [ ] Gate F — bounded runtime exercise using existing qualified AU data and accepted admission paths.
- [ ] Gate G — targeted security/API acceptance and runbook reconciliation only for changed surfaces.
- [ ] Gate H — close/freeze M2.4.6 and hand the operating model to M2.4.7 controlled scale.

## Admission progress — 15 September 2026

The accepted CF-245 official-course-URL admission path was reused without redesign:

- 272 latest qualified candidates checked;
- 269 eligible/applied;
- 122 canonical changes;
- Search projection applied 122 changed rows;
- website/Search `official_course_url` coverage is now **527**.

Website v3.1 runtime verification with `has_link=true` returns total **527** and includes admitted official URL, regulatory tuition, intake and English summaries.

Observed-artifact deterministic replay currently has no further intake/English candidates: 0 intake courses / 0 English courses. Remaining 457 provider-current-tuition candidates are already classified for Layer 3 fee validation and are not a blocker for current website handover.

## Scope boundaries

M2.4.6 must not reopen CF-093, manufacture data, copy AU qualification into NZ, introduce generic Layer 3 auto-approval, bypass Layer 4, weaken Evidence/security, or delay consumer handover merely to improve non-blocking orchestration logic.

Broad throughput/coverage expansion belongs to M2.4.7. Consumer/API operationalisation belongs to M2.4.8, but accepted consumer-ready data may be handed over continuously rather than waiting for that gate to begin.

## Exact next gate

1. Verify the current website v3.1 consumer contract against the newly projected data and preserve the runtime sample/evidence.
2. Complete only the minimum duplicate/unsafe-execution protection needed for bounded waves.
3. Run one bounded qualified AU operational exercise using existing accepted paths.
4. If green, close M2.4.6 and move immediately to M2.4.7 scale while the website consumer uses the already-admitted dataset.
