# CourseFinder M2 → Production Delivery Plan / TSOW v1.3

**Issued:** 25 August 2026  
**Status:** CURRENT  
**Supersedes:** v1.2  
**Programme baseline:** Master Project Plan v1.70  
**Change Control:** CF-CHG-20260825-036

## 1. Status update

M2.2 is CLOSED/PASS. M2.3 is ACTIVE / EXPANDED into the production-grade Data Operations maturity gate for accepted Layer 1 and Layer 2 operations, unified navigation, Scholarship decision support, Course contextual intelligence and role-based operating guidance.

The existing 12-hour M2.3 allocation remains a planning baseline only. This scope revision does not create or infer new billable time. Actual engagement time must be separately confirmed.

## 2. M2.3 technical scope

| Task ID | Workstream | Actionable task | Planning allocation | Acceptance / evidence |
|---|---|---|---:|---|
| M2.3-01 | Layer 1 production operations | Reclassify accepted Layer 1 from experimental to production-grade; inventory every accepted regulatory Provider/Course source and establish source certification matrix | 1.0 | every source READY / CONDITIONAL / BLOCKED with evidence |
| M2.3-02 | Batch policy | Define/sort/vet source-specific page/batch limits, concurrency, rate limits, timeout, retries/backoff, resume cursor, max safe run window and freshness policy; centralise configuration where practical | 1.0 | validated batch policy registry + replay tests |
| M2.3-03 | Layer 2 scale | Continue production-shaped scheduling, explicit provider selection, retry/resume, fallback and budget controls; qualify NZ first-party Layer 2 profiles | 1.5 | bounded repeatable AU/NZ execution with no surprise paid fallback |
| M2.3-04 | Evidence | Complete idempotent Evidence capture, retention, dedupe, capacity thresholds and growth economics; reconcile legacy Evidence safely | 0.75 | storage/replay/dedupe UAT |
| M2.3-05 | AU/NZ data scale | Run representative/broad Course and Scholarship deterministic enrichment batches with identity/fee/source guards | 1.5 | completeness/quality/Layer3-fallout metrics |
| M2.3-06 | Unified Data Operations UX | Redesign navigation into one Data Operations parent workspace covering Overview, L1, L2, L3 handoff, L4 review, Evidence, Jobs/Runs; remove redundant overhead | 1.5 | role-safe desktop/mobile journey PASS |
| M2.3-07 | Course detail intelligence | Add applicable QILT/PRISMS contextual panels, Scholarship coverage, Evidence/freshness and unresolved/readiness signals without flattening source grain | 1.0 | semantic + browser UAT |
| M2.3-08 | Scholarship Selection mini-app | Build transparent criteria/filter/ranking decision support across governed Provider/Course/Scholarship data, with explanations and coverage/confidence handling | 1.5 | deterministic scoring + evidence + missing-data UAT |
| M2.3-09 | Guides / quick tours | Update Admin/User Guides by role; include screen mock-ups/representative screenshots, quick tours, recommended workflows and semantic traps | 0.75 | guides match deployed UI |
| M2.3-10 | Economics / dashboards | Surface source health, freshness, active batches, retry backlog, Evidence growth, paid-provider consumption and L3/L4 fall-out; retain cost/entity and storage/entity KPIs | 0.5 | operating KPI baseline |
| M2.3-11 | Consolidated Auto-UAT | Database/API/security/storage/browser/mobile/performance/replay and negative-authorisation regression including M1/M2.1/M2.2 invariants | 1.0 | M2.3 PASS/BLOCKED evidence |
|  |  | **M2.3 total** | **12.0** | |

## 3. Unified Data Operations target

**Parent: Data Operations**

- Overview
- Layer 1 — Regulatory
- Layer 2 — Enrichment
- Layer 3 — AI Interpretation (handoff/readiness only until M2.4)
- Layer 4 — Human Resolution
- Evidence & Provenance
- Jobs / Runs

Preferred broader Admin structure:

- Dashboard
- Catalogue / PIM
- Data Operations
- Data Quality
- Scholarship Selection
- Search / Publication where authorised
- Administration / Settings
- Help / Guides

Duplicated top-level ingestion/pipeline/source/job/evidence pages should be consolidated where this can be done without weakening role boundaries or useful deep links.

## 4. Layer 1 source/batch certification rule

For every accepted Layer 1 regulatory source, capture:

- source authority and source identifier;
- country/entity coverage;
- adapter/runtime;
- source-native page/batch constraints;
- configured CourseFinder batch limit;
- concurrency and rate limit;
- timeout;
- retry/backoff;
- resume/checkpoint semantics;
- maximum safe execution duration;
- freshness SLA;
- idempotent replay/result invariants;
- observed operational performance;
- blocker/recovery procedure;
- certification state READY / CONDITIONAL / BLOCKED.

Do not apply one generic batch size to materially different authorities without source evidence.

## 5. Scholarship Selection rules

The mini-app is governed decision support, not an admissions workflow. It may rank/filter based on source-supported criteria, but:

- criteria and weights must be explicit/inspectable;
- missing data is not zero;
- coverage limitations must be visible;
- each recommendation explains match/rank factors;
- every factual claim links to governed source/Evidence where available;
- no invented Scholarship eligibility, values, cycles or applicability;
- no unsupported universal “best university/course” assertion.

## 6. Course detail QILT/PRISMS rule

QILT and PRISMS are contextual sources and retain their accepted source grain/reporting period. Provider-level/contextual signals must be labelled as such and must not be silently transformed into canonical Course facts.

## 7. UAT requirements

Automated UAT includes at minimum:

- per-source Layer 1 batch-limit/replay/idempotency tests;
- batch resume after transient failure;
- no implicit paid-provider fallback;
- Evidence unchanged-content replay and duplicate-object cleanup;
- source certification status rendering;
- Data Operations navigation and role visibility;
- Course QILT/PRISMS semantic placement;
- Scholarship ranking determinism, explanation and missing-data behaviour;
- desktop/mobile quick-tour/navigation checks;
- security/negative authorisation;
- catalogue/Search/publication invariants.

## 8. Current runtime evidence

- first M2.3 real UQ batch completed 3/3 resolved at Layer 2 after one bounded retry;
- vendor units: 3;
- recorded vendor cost: USD 0;
- paid Firecrawl authority remains unverified and is prohibited from implicit batch use;
- Evidence idempotent replay/dedupe controls are live;
- NZ first-party Layer 2 Course detail coverage is a current gap.

## 9. Boundary

M2.3 does not authorise the separate M2.5 Production project/cutover, Layer 3 AI execution beyond handoff/readiness, broad Publication, Zoho cutover or final Production handover.
