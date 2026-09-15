# M2.4.6 RUNSHEET — Production Operations Model

**Status:** ACTIVE  
**Opened:** 2026-09-15 AEST  
**Predecessor:** M2.4.5 CLOSED / PASS / FROZEN  
**Successor:** M2.4.7 Controlled Operational Scale  
**Programme authority:** `../M2.4.6-M2.4.9-OPERATIONS-PLAN.md`

## Accepted predecessor baseline

- Pilot main: `e62c01cadaf43efa8c3d8ea57625c23874d1b010`.
- Visible accepted release: v2.15.79 / package 0.1.6.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- Production Supabase: not provisioned.
- CF-093: CLOSED / PASS / HISTORICAL ONLY.
- CF-245: CLOSED / PASS; operational telemetry and Enrichment Operations reporting are accepted baseline capabilities.
- Final M2.4.5 acceptance: dedicated CF-245 UAT `34926246733`, generic targeted UAT `34926246675`, build/smoke `34926246673`, Cloudflare deployment all PASS.

## M2.4.6 objective

Define and prove the practical day-to-day operating model using the accepted Pilot/runtime, without broad scale expansion and without weakening source qualification, Layer authority, Evidence, identity, security or Search/publication rules.

## Gates

- [x] Gate A — predecessor baseline reconciled and frozen.
- [ ] Gate B — dispatcher/wave operating contract: who/what dispatches, eligible scopes, Evidence reuse-first, deterministic L2, bounded L3 and L4 escalation.
- [ ] Gate C — failure/recovery contract: retries, parking, stale-item recovery, idempotency/replay and operator intervention boundaries.
- [ ] Gate D — resource controls: provider quotas, paid-attempt/cost ceilings, concurrency/rate stop conditions and fail-closed behaviour.
- [ ] Gate E — operating ownership/observability: operator ownership, actionable status, hourly/daily metrics, audit/evidence drill-down and run attribution.
- [ ] Gate F — bounded runtime exercise: prove the model on qualified AU work; NZ only where qualification genuinely exists.
- [ ] Gate G — targeted security/browser/UAT acceptance and runbook/admin-guide reconciliation.
- [ ] Gate H — close/freeze M2.4.6 and hand accepted model to M2.4.7 controlled scale.

## Scope boundaries

M2.4.6 may refine operational orchestration, recovery and controls only where required to prove the operating model. It must not:

- reopen CF-093;
- manufacture data or copy AU qualification assumptions into NZ;
- introduce generic Layer 3 auto-approval;
- bypass Layer 4 consequential authority;
- expose private Evidence/base tables;
- merge acquisition with canonical/Search publication authority;
- expand country onboarding beyond governed AU/NZ scope;
- start M2.5 or provision Production.

Broad throughput/coverage expansion belongs to M2.4.7 after this operating model is accepted.

## Exact next gate

Reconcile the current Pilot dispatcher/scheduler/run-item/provider-attempt implementation and the accepted CF-245 telemetry against Gate B. Document the existing dispatcher, ownership, wave eligibility and stop conditions first; create a new Change Control only for demonstrated gaps requiring implementation changes.
