# M2.4.7 RUNSHEET — Controlled Operational Scale

**Status:** ACTIVE  
**Opened:** 2026-09-15 AEST  
**Predecessor:** M2.4.6 CLOSED / PASS / FROZEN  
**Accepted Pilot baseline:** `90ddbdf28bfad57eb8d5a0ede1b8e506e252908a`  
**Successor:** M2.4.8 Consumer & Data Operations Readiness  
**Programme authority:** `../M2.4.6-M2.4.9-OPERATIONS-PLAN.md`

## Objective

Scale the accepted operating model across genuinely qualified AU/NZ scopes while measuring useful enrichment gain, throughput, failures, cost, latency and recovery. Admit safe deterministic data continuously and keep website handover moving in parallel.

## Gates

- [x] Gate A — M2.4.6 accepted/frozen at Pilot `90ddbdf28bfad57eb8d5a0ede1b8e506e252908a`.
- [ ] Gate B — select the highest-value genuinely qualified controlled scale scope from runtime backlog/admission opportunity; do not select by raw queue size alone.
- [ ] Gate C — execute bounded multi-wave scale using accepted dispatcher/authority controls; AU first unless NZ qualification is independently proven.
- [ ] Gate D — measure throughput, deterministic admission gain, L3/L4 handoff, failure/block rate, vendor units/cost, latency and recovery.
- [ ] Gate E — continuously project accepted deterministic changes into governed Search and verify website/API deltas.
- [ ] Gate F — tune Evidence reuse/retry/provider routing only if measurements show a material blocker; no speculative redesign.
- [ ] Gate G — targeted security/UAT/reconciliation for changed surfaces and scale outcomes.
- [ ] Gate H — close/freeze M2.4.7 and hand to M2.4.8 consumer/support readiness.

## Starting consumer baseline

- Search courses: 33,105;
- official-course URLs: 527;
- intakes: 487;
- English requirements: 520;
- provider-current tuition: 161;
- website v3.1 `has_link=true`: 527;
- website-admitted scholarships: 0.

## Guardrails

- CF-093 and CF-246 remain closed historical acceptance evidence.
- Do not manufacture data or copy AU qualification into NZ.
- Do not introduce generic Layer 3 auto-approval or bypass Layer 4.
- Do not increase scheduler frequency/concurrency merely to raise throughput.
- Acquisition success does not itself authorise canonical/Search publication.
- Website handover of already-admitted data must not wait for 100% enrichment completeness.

## Exact next gate

Reconcile runtime qualified AU profiles against current queueable backlog and already-admitted coverage. Select the first controlled scale target by expected safe admission value, then run a bounded wave and measure the end-to-end gain before increasing scope.
