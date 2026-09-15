# M2.4.5 RUNSHEET — Admin/PIM Hardening & Pre-Production Operational Readiness

**Status:** CLOSED / PASS / FROZEN  
**Opened:** 2026-09-03 10:28 AEST  
**Closed/Reconciled:** 2026-09-15 AEST  
**Predecessor:** M2.4.4 CLOSED / PASS / FROZEN  
**Successor:** M2.4.6 Production Operations Model — ACTIVE

## Accepted baseline

- Pilot main: `e62c01cadaf43efa8c3d8ea57625c23874d1b010`.
- Visible accepted release: v2.15.79 / package 0.1.6.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- CF-093: CLOSED / PASS / HISTORICAL ONLY; do not reopen.
- CF-245: CLOSED / PASS; merged PRs #91–#95.
- Production Supabase: not provisioned.
- M2.5 remains paused until M2.4.9 records explicit GO.

## Final CF-245 gate status

- [x] Gate A — historical workload cause reconciled.
- [x] Gate B — common enrichment operational telemetry live.
- [x] Gate C — AU/NZ backlog classification live.
- [x] Gate D — bounded deterministic replay/admission baseline accepted.
- [x] Gate E — governed Search/publication reconciliation accepted.
- [x] Gate F — Enrichment Operations Admin reporting, security and deployed acceptance PASS.
- [x] Gate G — tuning intentionally not performed; practical tuning/scaling transferred to M2.4.6/M2.4.7.
- [x] Gate H — M2.4.5 closure/freeze accepted under the M2.4.6–M2.4.9 operations sequence.

## Final operational evidence

Latest accepted AU coverage snapshot:

- Search courses: 33,105;
- regulatory tuition: 26,457;
- intakes: 487;
- English requirements: 520;
- official course URLs: 421;
- provider-current tuition: 161;
- website-admitted scholarships: 0.

NZ remains unexpanded for these enrichment fields pending governed source/profile/discovery/policy qualification.

Real hourly coverage history exists: intake/English moved from 161/161 at the earlier hourly baseline to 487/520 by the 02:00–03:00 UTC snapshots on 15 September 2026.

## Recovery / final acceptance

- Generic run `34921633392`: rejected as CF-245 acceptance evidence because it selected an unrelated Layer 1 suite.
- Dedicated run `34925786691`: valid CF-245 test; exposed genuine statement-timeout failures.
- Runtime profiling: `pipeline.layer2_enrichment_hourly_v1` approximately 5.4 s by itself against an authenticated 8 s statement budget.
- PR #95 / migration `20260915034453_cf_245_enrichment_hourly_admin_cache_v1`: private observational cache correction, no mutation-authority or scheduler-policy change.
- Dedicated CF-245 deployed UAT `34926246733`: PASS.
- Generic targeted deployed UAT `34926246675`: PASS.
- Build/smoke `34926246673`: PASS.
- Cloudflare Worker deployment: PASS, version `c4eef0db-5910-42e7-ab50-0b9d701c5f07`.

## Handoff

M2.4.5 is frozen. Do not add new operating-model design, scaling or tuning here.

Continue from `project-runsheets/milestone-2/m2.4/M2.4.6-M2.4.9-OPERATIONS-PLAN.md` and the active `m2.4.6/` continuity set. M2.4.6 owns dispatcher/waves, Evidence reuse-first, deterministic L2, bounded L3/L4 handling, retries/parking, stale recovery, idempotency, quota/cost controls, stop conditions, ownership and operational metrics.
