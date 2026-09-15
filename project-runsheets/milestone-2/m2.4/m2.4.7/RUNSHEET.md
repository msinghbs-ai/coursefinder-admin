# M2.4.7 RUNSHEET — Controlled Operational Scale

**Status:** ACTIVE — FIRST QUALIFIED SCALE WAVE RUNNING  
**Opened:** 2026-09-15 AEST  
**Predecessor:** M2.4.6 CLOSED / PASS / FROZEN  
**Accepted Pilot baseline:** `90ddbdf28bfad57eb8d5a0ede1b8e506e252908a`  
**Successor:** M2.4.8 Consumer & Data Operations Readiness  
**Programme authority:** `../M2.4.6-M2.4.9-OPERATIONS-PLAN.md`

## Objective

Scale the accepted operating model across genuinely qualified AU/NZ scopes while measuring useful enrichment gain, throughput, failures, cost, latency and recovery. Admit safe deterministic data continuously and keep website handover moving in parallel.

## Gates

- [x] Gate A — M2.4.6 accepted/frozen at Pilot `90ddbdf28bfad57eb8d5a0ede1b8e506e252908a`.
- [x] Gate B — first scale target selected by governed admission opportunity: RMIT qualified Course profile. Current queueable backlog is 261 courses / 303 missing field rows, including 37 intake and 5 English gaps plus provider-current tuition requiring bounded L3. UQ has only 3 deterministic intake/English gaps. Flinders/Curtin queue rows were not selected because no matching admitted Course-Fact source qualification was present.
- [ ] Gate C — bounded controlled scale execution ACTIVE: RMIT university request `f120fb4b-ec69-4f2c-8147-550a338c6f3d`, managed route, 25-item wave, `schedule_remaining=false`.
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

## First scale-wave evidence

RMIT is fully enabled/unpaused, current profile validation is valid, execution policy enabled, qualification status `qualified`, `apply_admitted=true`, `search_admitted=true`, and admitted domains include official URL, international fee, intake and English requirement.

The first controlled request started with exactly 25 items and automatic continuation disabled. Initial batch `13f33fcf-05b9-4379-b214-cf4760bbe1f3` is processing under the accepted managed route. No broad country run or scheduler/concurrency increase has been authorised.

## Guardrails

- CF-093 and CF-246 remain closed historical acceptance evidence.
- Do not manufacture data or copy AU qualification into NZ.
- Do not introduce generic Layer 3 auto-approval or bypass Layer 4.
- Do not increase scheduler frequency/concurrency merely to raise throughput.
- Acquisition success does not itself authorise canonical/Search publication.
- Website handover of already-admitted data must not wait for 100% enrichment completeness.

## Exact next gate

Complete the 25-item RMIT wave, reconcile terminal outcomes and newly observed deterministic fields, admit only qualified safe changes through existing paths, refresh governed Search, and measure the website delta before authorising another wave or a wider scope.
