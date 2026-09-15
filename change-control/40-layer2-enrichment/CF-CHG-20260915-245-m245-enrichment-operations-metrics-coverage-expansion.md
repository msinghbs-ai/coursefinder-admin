# CF-CHG-20260915-245 — M2.4.5 Enrichment Operations, Metrics & Coverage Expansion

**Status:** CLOSED / PASS — ACCEPTED M2.4.5 BASELINE; OPERATIONS FOLLOW-UPS TRANSFERRED TO M2.4.6+  
**Milestone:** M2.4.5 — Pre-Production Hardening  
**Opened:** 15 September 2026 AEST  
**Closed/Reconciled:** 15 September 2026 AEST  
**Primary category:** 40-layer2-enrichment  
**Historical baseline:** CF-CHG-20260910-093 CLOSED / PASS; do not reopen  
**Accepted Pilot main:** `e62c01cadaf43efa8c3d8ea57625c23874d1b010`  
**Merged CF-245 implementation/recovery:** PR #91, #92, #93, #94, #95  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Visible accepted release:** v2.15.79 / package 0.1.6  
**Production:** not provisioned; M2.5 remains PAUSED until M2.4.9 GO

## Accepted outcome

CF-245 established a measurable, authority-preserving enrichment operating baseline for AU/NZ without changing Layer 1 identity, canonical authority, generic Layer 3 approval, Layer 4 escalation, Search/publication admission, Evidence access or security boundaries.

Accepted capabilities:

- common Layer 2 operational ledger and hourly funnel telemetry;
- AU/NZ backlog classification before workload generation;
- bounded deterministic replay/admission paths only where source identity and Evidence qualification pass;
- hourly AU/NZ coverage snapshots independent of scheduler ticks;
- rank-gated Enrichment Operations Admin reporting;
- provider yield/latency, cost/units/errors, stop reasons, admissions, Jobs/Evidence drill-down and coverage velocity;
- dedicated CF-245 deployed UAT route;
- persisted private hourly Admin-report cache to keep browser reporting inside the authenticated statement budget without weakening data authority.

## Final runtime / coverage evidence

Current governed Search/consumer substrate remains **33,105 courses** and **26,457 regulatory tuition**.

Latest CF-245 snapshot evidence on 15 September 2026:

- AU intake coverage: **487**;
- AU English-requirement coverage: **520**;
- AU official-course-URL coverage: **421**;
- AU provider-current tuition coverage: **161**;
- website-admitted scholarships: **0**;
- NZ enrichment coverage for these governed fields remains **0** pending qualification.

Real hourly history exists. Snapshot observations at 00:00/01:00 UTC retained the earlier 161/161 intake/English baseline; by 02:00/03:00 UTC the accepted runtime recorded 487/520. No fabricated baseline was used.

PR #93 also reconciled stored qualified Evidence replay and bounded production-like waves while preserving fail-closed Layer 3 fee validation. Qualified provider-current tuition candidates remain isolated from canonical/Search mutation until their governed validation gate passes.

## Recovery / acceptance evidence

### Routing recovery

Generic deployed-UAT run `34921633392` did not test CF-245: retained evidence showed suite `m2-4-1-layer1-operations`. That run was classified as UAT-routing/currentness evidence, not a CF-245 product failure.

PR #94 added the dedicated CF-245 deployed acceptance nomination. The first dedicated run `34925786691` then exposed a genuine runtime defect: concurrent Layer 2 Admin reads returned HTTP 500 because PostgreSQL statements exceeded the authenticated 8-second budget. Direct profiling showed `pipeline.layer2_enrichment_hourly_v1` took approximately 5.4 seconds by itself.

PR #95 corrected reporting mechanics only:

- applied Pilot migration `20260915034453_cf_245_enrichment_hourly_admin_cache_v1`;
- persisted the existing hourly observational projection in a private service-role cache;
- retained the existing rank-gated `security.admin_enrichment_operations_read(jsonb)` response contract;
- added an independent hourly cache refresh;
- did **not** alter enrichment scheduler frequency/concurrency, provider routing, budgets, Layer authority, canonical admission, Search/publication or Evidence security.

Final nominated evidence on accepted Pilot main `e62c01c...`:

- dedicated CF-245 deployed UAT `34926246733`: **PASS**;
- generic targeted deployed UAT `34926246675`: **PASS**;
- build-and-smoke `34926246673`: **PASS**;
- Cloudflare Worker deployment: **PASS**, version `c4eef0db-5910-42e7-ab50-0b9d701c5f07`.

## Gate disposition

- Gate A — historical workload explanation: **PASS**.
- Gate B — common telemetry: **PASS**.
- Gate C — AU/NZ backlog classification: **PASS**.
- Gate D — bounded deterministic expansion/admission: **PASS FOR M2.4.5 BASELINE**.
- Gate E — Search/publication reconciliation: **PASS**.
- Gate F — Enrichment Operations reporting/security/deployed acceptance: **PASS**.
- Gate G — evidence-led tuning: **TRANSFERRED TO M2.4.6/M2.4.7**; throughput tuning was intentionally not authorised inside M2.4.5 because evidence did not justify it.
- Gate H — M2.4.5 acceptance: **PASS / CLOSED** under the approved M2.4.6–M2.4.9 operations sequence.

This transfer is not a waiver of operational evidence. The programme-level `M2.4.6-M2.4.9-OPERATIONS-PLAN.md` deliberately moves daily operating history, practical dispatcher/retry/cost procedures, broader AU/NZ scale, consumer support and dress rehearsal into M2.4.6–M2.4.9 before Production.

## Successor gate

Accepted CF-245 outputs are frozen as the predecessor baseline for **M2.4.6 — Production Operations Model**.

M2.4.6 must prove the practical operating model for dispatcher/waves, Evidence reuse-first, deterministic L2, bounded L3, L4 escalation, retries/parking, stale recovery, idempotency, quotas/cost ceilings, stop conditions, operator ownership and operational metrics. Broader scaling belongs to M2.4.7.

M2.5 and Production remain paused until M2.4.9 records explicit GO.
