# CourseFinder M2 → Production Delivery Plan / TSOW v1.2

**Issued:** 25 August 2026  
**Status:** CURRENT  
**Supersedes:** v1.1  
**Programme baseline:** Master Project Plan v1.69  
**Change Control:** CF-CHG-20260825-036

## 1. Status update

M2.2 is CLOSED/PASS. M2.3 is ACTIVE EARLY by explicit user instruction to progress immediately after M2.2 closure. Planned-hour allocations remain unchanged; technical execution is not a billable-time entry.

## 2. Milestone envelope

| Milestone | Status | Planned hours | Principal outcome |
|---|---|---:|---|
| M2.0 | COMPLETE | 8 | programme consolidation / Auto-UAT |
| M2.1 | CLOSED / PASS | 3 | Layer 2 platform |
| M2.2 | CLOSED / PASS | 10 | Security & Production foundation + bounded Search showcase |
| **M2.3** | **ACTIVE EARLY** | **12** | L2 scale enrichment + L1/L2 UX maturity |
| M2.4 | PLANNED | 7 | L3 AI operations / pre-blackout |
| Blackout 16–30 Sep | NO DELIVERY | 0 | no planned project delivery |
| M2.5 | PLANNED | 12 | clean Production stack deployment/acceptance |
| M3 | PLANNED | 10 | consumer API / Zoho |
| M4 | PLANNED | 8 | Search/publication/final Production handover |

No new confirmed engagement hours are recorded by this version. Supabase Pro remains an expense separate from engineering time.

## 3. M2.3 detailed technical scope

| Task ID | Workstream | Actionable task | Planned hours | Current state / acceptance |
|---|---|---|---:|---|
| M2.3-01 | Vendor | Configure paid Firecrawl route and controlled provider-budget/concurrency policy | 1.0 | BLOCKED/PENDING entitlement verification; credential exists but live billing metadata records Free |
| M2.3-02 | Pipeline | Implement/validate production-shaped scheduling, batches, retry/resume, provider fallback and rate controls | 2.0 | ACTIVE; schema exists, 0 run batches/items at initiation |
| M2.3-03 | Evidence | Implement hash dedupe, retention classes, evidence-growth metrics and 60/75/90% storage thresholds | 1.0 | ACTIVE; all rows hashed, but legacy lifecycle and duplicate-hash gaps evidenced |
| M2.3-04 | Data | Execute representative/broad AU/NZ Course and Scholarship enrichment batches with identity/fee guards | 3.0 | PENDING control readiness |
| M2.3-05 | Admin UX | Mature Layer 1 Regulatory and Layer 2 Enrichment scorecards, queues, entity drill-down and Evidence links | 2.0 | PENDING source/runtime gap review |
| M2.3-06 | Economics/Quality | Measure pages/entities, vendor units, cost/entity, cost/resolved entity, retry/fallback and storage/entity | 1.0 | PENDING batch evidence |
| M2.3-07 | UAT | Run database/API/security/storage/browser/performance/replay regression suites | 2.0 | PENDING final implemented scope |
|  |  | **M2.3 total** | **12.0** | |

## 4. Initiation evidence

Pilot runtime at start:

- Provider Attempts: 38;
- Evidence rows: 1,632;
- Source Profiles: 6;
- run batches/items: 0 / 0;
- Scholarship discovery candidates: 42;
- Course discovery candidates: 0;
- Evidence retention classes: 1,567 legacy; 65 standard_365;
- 47 duplicate content-hash groups containing 525 duplicate rows beyond the first;
- Firecrawl/Scrape.do/ZenRows have Vault credential references; Firecrawl billing metadata still says Free.

## 5. Acceptance constraints

M2.3 must not silently absorb:

- Layer 3 AI operational authority;
- broad Publication;
- Production consumer traffic;
- Zoho cutover;
- clean Production deployment/restore acceptance;
- final Search/publication handover.

M2.1/M2.2 security, identity, Evidence, fee and Search boundaries remain regression gates.

## 6. Next implementation order

1. prove/configure provider budgets and entitlement;
2. validate batch/retry/resume/fallback controls;
3. close Evidence lifecycle/dedupe/threshold gaps;
4. execute bounded representative scale batches;
5. measure cost/quality/storage economics;
6. mature only evidenced Layer 1/L2 UX gaps;
7. run consolidated automated UAT and close or block with evidence.