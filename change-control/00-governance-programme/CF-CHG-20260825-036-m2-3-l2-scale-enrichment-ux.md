# CF-CHG-20260825-036 — M2.3 Layer 2 Scale Enrichment & L1/L2 UX Maturity

**Status:** APPROVED / IN PROGRESS — EARLY START AFTER M2.2 PASS  
**Category:** 00-governance-programme  
**Initiated:** 25 August 2026 21:26 AEST (+10:00)  
**Origin:** M2.2 → M2.3 sequential progression  
**Owner:** CourseFinder programme / Layer 2 operations

## Trigger

M2.2 is CLOSED / PASS. The user explicitly authorised immediate progression to the next accepted gate. Master Project Plan v1.68 and the retained v1.67 scope identify the next gate as **M2.3 — Layer 2 Scale Enrichment & L1/L2 UX Maturity**.

The planned-hours baseline remains 12 hours for M2.3. Technical execution does not create billable time entries; confirmed engagement time remains separately governed.

## Scope

M2.3 owns:

1. paid-provider readiness and controlled provider budgets/concurrency;
2. production-shaped Layer 2 scheduling, batches, retry/resume, provider fallback and rate controls;
3. Evidence hash dedupe, retention classes, evidence-growth metrics and storage thresholds;
4. representative/broad AU/NZ Course and Scholarship enrichment with identity/fee guards;
5. mature Layer 1 Regulatory and Layer 2 Enrichment operational UX;
6. scale/economics measurements;
7. automated database/API/security/storage/browser/performance/replay regression.

## Authority boundaries

M2.3 does not authorise:

- Layer 3 AI interpretation beyond the accepted handoff boundary;
- broad Publication;
- Production consumer traffic;
- Zoho cutover;
- final Production handover;
- synthetic/fabricated Course or Scholarship facts.

Layer 1–4 authority semantics remain unchanged and Layer 4 remains terminal.

## Initiation reconciliation

Inherited accepted Pilot SHA: `38ad08bb75ee7cf26a0a701a3ae008d1563b915b`.

Current provider registry includes Direct HTTP, Scrape.do, ScraperAPI, Firecrawl and ZenRows. Live billing metadata still records Firecrawl as `plan_tier=free`; no paid Firecrawl entitlement is assumed. M2.3-01 cannot be called PASS until actual paid entitlement/routing is verified or an explicit alternative provider decision is approved.

M2.2 Search/read changes and Supabase Pro security controls are inherited and must remain regression-safe.

## Task baseline

| ID | Task | Initial state |
|---|---|---|
| M2.3-01 | paid Firecrawl route + provider budget/concurrency policy | BLOCKED/PENDING entitlement verification |
| M2.3-02 | production-shaped scheduling/batch/retry/resume/fallback/rate controls | RECONCILE / IMPLEMENT |
| M2.3-03 | Evidence dedupe/retention/growth/threshold controls | RECONCILE / IMPLEMENT |
| M2.3-04 | representative/broad AU/NZ Course + Scholarship enrichment batches | PENDING controls/UAT |
| M2.3-05 | Layer 1/Layer 2 Admin UX maturity | RECONCILE / IMPLEMENT only genuine gaps |
| M2.3-06 | scale/economics KPI baseline | PENDING runtime measurements |
| M2.3-07 | consolidated automated UAT | PENDING final implemented scope |

## Acceptance

M2.3 closes only when implemented scope passes automated database/API/security/storage/browser/performance/replay UAT, scale/economics evidence is retained, M2.1/M2.2 invariants remain safe, and any paid-provider blocker is either resolved or explicitly separated from the accepted scope by programme Change Control.

## Rollback

Scale operations must be bounded and replayable. Any batch that threatens canonical identity, fee semantics, Evidence integrity, security, storage capacity or provider budget is stopped and retained as blocker evidence. Publication remains unaffected.

## Documentation

Maintain Master Project Plan/TSOW, Running Build, Change Control Register, Operations Runbook, Data Flow & Feature Atlas, relevant Admin/PIM guide material, milestone meeting record and M2.3 UAT evidence throughout execution.