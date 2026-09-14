# M2.4.5 RUNSHEET — Admin/PIM Hardening & Pre-Production Operational Readiness

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 CLOSED / PASS; CF-245 ENRICHMENT OPERATIONS ACTIVE  
**Opened:** 2026-09-03 10:28 AEST  
**Reconciled:** 2026-09-15 AEST  
**Predecessor:** M2.4.4 CLOSED / PASS / FROZEN  
**Successor:** M2.5 Production Readiness — PAUSED AT P0

## Current baseline

- Accepted Pilot main: `7196c5d2fade8830ec371c663b008e8a47e01f74`.
- Visible accepted release: v2.15.79 / package 0.1.6.
- Pilot Supabase: `fxcwkweaxjtknorudmwp`.
- CF-093: CLOSED / PASS / HISTORICAL ONLY; do not reopen.
- Production Supabase: not provisioned.
- Current operational authority: `CF-CHG-20260915-245` — M2.4.5 Enrichment Operations, Metrics & Coverage Expansion.

## Accepted inherited gates

- [x] CF-093 consequential scheduler/orchestrator acceptance closed.
- [x] Exact Preview/binding/fingerprint/identity provenance preserved.
- [x] Deterministic Layer 2 remains Evidence-preserving and fail-closed.
- [x] Generic scheduler Layer 3 auto-approval prohibited.
- [x] Layer 4 and Search/Publication remain separate governed boundaries.
- [x] Accepted v2.15.79 runtime/release baseline established.

## CF-245 Gate A — measurement contract and baseline

- [ ] Define one end-to-end funnel from missing/stale/due through publication.
- [ ] Produce field-level hourly and daily measurements.
- [ ] Include latency, retry, Evidence, cost/unit and provider/source dimensions.

## CF-245 Gate B — telemetry wiring

- [ ] Reconcile all active Layer 2 acquisition paths to a common execution ledger.
- [ ] Populate item-level fields targeted/resolved, outcome, failure, response/extraction time, Evidence and cost telemetry.
- [ ] Expose countable `canonical_mutation_authorised=false` reason codes.

## CF-245 Gate C — demand/backlog generation

- [ ] Classify AU/NZ missing/stale facts as queueable, blocked, not-applicable or awaiting source/profile qualification.
- [ ] Generate governed work demand for official URL, intake, English, provider-current tuition and scholarships where valid.

## CF-245 Gate D — AU/NZ operational coverage expansion

- [ ] Expand bounded country/state/provider/course refresh/work policies beyond pilot-sized coverage.
- [ ] Prove real recurring queues produce measurable coverage movement.

## CF-245 Gate E — admission/publication reconciliation

- [ ] Trace Evidence → extraction → admitted facts → Search/publication → website/API visibility.
- [ ] Reconcile field-level coverage deltas without weakening authority boundaries.

## CF-245 Gate F — Admin reporting

- [ ] Provide Enrichment Operations reporting separate from Scheduled Tasks configuration/health.
- [ ] Show backlog, throughput, field coverage growth, provider/source yield, blockers, errors and cost/yield.
- [ ] Drill down to jobs and Evidence.

## CF-245 Gate G — evidence-led tuning

- [ ] Tune only after comparable observations exist.
- [ ] Measure before/after useful facts per acquisition, coverage velocity, latency, errors, retries and cost per admitted fact.
- [ ] Audit behavioural tuning through governed tuning events/change-control evidence.

## CF-245 Gate H — acceptance

- [ ] Representative bounded AU/NZ workloads complete.
- [ ] Hourly and daily operational reports are meaningful and reproducible.
- [ ] Applicable targeted/bounded CI/UAT/security gates green.
- [ ] Continuity and Change Control reconciled.

## Exact next action

Reconcile the 245 recent successful `layer2_acquisition_v2/course_facts` jobs against provider attempts, Evidence, extraction/candidate/admission stores and Search/publication outputs; count the exact causes of `canonical_mutation_authorised=false`; then wire the real execution path into item/batch telemetry and produce the first actual hourly funnel report before changing scheduler frequency or concurrency.
