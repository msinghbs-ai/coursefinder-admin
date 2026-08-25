# CourseFinder Master Project Plan v1.69

**Issued:** 25 August 2026  
**Status:** CURRENT  
**Supersedes:** v1.68  
**Programme Change Controls:** CF-CHG-20260825-032 CLOSED/PASS; CF-CHG-20260825-036 M2.3 ACTIVE

## 1. Baseline rule

M1 remains frozen. M2.1 and M2.2 are CLOSED/PASS. M2.3 starts early on 25 August 2026 by explicit user instruction to progress immediately after closure. Planned-hour allocations are unchanged and technical execution does not create billable time entries.

No M2.2/M2.3 work grants broad Publication, Production consumer exposure, Zoho cutover or final Production handover authority.

## 2. Authority model

`Layer 1 Authoritative / Regulatory → Layer 2 Deterministic Acquisition & Extraction → Layer 3 AI-assisted Evidence Interpretation → Layer 4 Human Resolution`

Layer 4 remains terminal. Search Projection, Search Visibility and Publication remain downstream product states.

## 3. Current milestone sequence

| Milestone | Status | Planned hours baseline | Outcome / current focus |
|---|---|---:|---|
| M2.0 | COMPLETE | 8 | programme consolidation and automated-UAT operating model |
| M2.1 | CLOSED / PASS | 3 | Layer 2 platform foundation |
| M2.2 | **CLOSED / PASS** | 10 | Pilot security/Production foundation + bounded deterministic Search showcase |
| **M2.3** | **ACTIVE EARLY** | **12** | L2 scale enrichment, Evidence economics/lifecycle and Layer 1/L2 UX maturity |
| M2.4 | PLANNED | 7 | L3 AI Operations and pre-blackout gate |
| Blackout | 16–30 Sep | 0 | no planned project delivery |
| M2.5 | PLANNED | 12 | clean Production establishment/deployment/restore acceptance |
| M3 | PLANNED | 10 | consumer API / Zoho integration |
| M4 | PLANNED | 8 | Search/publication/final Production handover |

The existing engagement-time record remains authoritative. No additional billable hours are inferred from M2.2 technical closure or M2.3 early start.

## 4. M2.2 accepted closure

Accepted Pilot SHA: `38ad08bb75ee7cf26a0a701a3ae008d1563b915b`.

Evidence:

- build `32840377937` PASS;
- deployed desktop/mobile UAT `32840377935` PASS;
- Supabase Pro leaked-password protection enabled and verified by live Security Advisor;
- deterministic exact/FTS/filter Search/read preview accepted;
- vector/hybrid explicitly deferred/not accepted;
- broad publication remains zero.

Running Build: `docs/coursefinder-running-build-v2.70.md`.

## 5. M2.3 objective

M2.3 delivers:

1. paid-provider readiness and controlled provider-budget/concurrency policy;
2. production-shaped scheduling, batches, retry/resume, provider fallback and rate controls;
3. Evidence hash dedupe, retention classes, growth metrics and storage thresholds;
4. representative/broad AU/NZ Course and Scholarship deterministic enrichment with identity/fee guards;
5. Layer 1 Regulatory and Layer 2 Enrichment Admin maturity;
6. provider/evidence economics and quality KPI baseline;
7. automated database/API/security/storage/browser/performance/replay regression.

## 6. M2.3 initiation reconciliation

Live Pilot state at M2.3 start:

- Layer 2 provider registry includes Direct HTTP, Scrape.do, ScraperAPI, Firecrawl and ZenRows;
- Firecrawl has a Vault secret but current billing metadata still records `plan_tier=free`; paid entitlement is **not assumed**;
- `pipeline.layer2_run_batches`: 0;
- `pipeline.layer2_run_items`: 0;
- Provider Attempts: 38;
- Evidence rows: 1,632;
- Source Profiles: 6;
- Scholarship discovery candidates: 42;
- Course discovery candidates: 0;
- Evidence retention: 1,567 legacy rows and 65 `standard_365` rows;
- all Evidence rows have content hashes, but 47 hash groups contain 525 duplicate rows beyond the first;
- current standard Evidence rows have retention/group metadata; legacy Evidence does not.

This demonstrates that scale-control schema exists but broad production-shaped batch execution and Evidence dedupe/lifecycle acceptance are not yet proven.

## 7. M2.3 task state

| ID | Task | Status |
|---|---|---|
| M2.3-01 | paid Firecrawl route + budget/concurrency policy | BLOCKED/PENDING entitlement verification; credential exists, metadata says free |
| M2.3-02 | production-shaped scheduling/batch/retry/resume/fallback/rate controls | ACTIVE RECONCILIATION |
| M2.3-03 | Evidence dedupe/retention/growth/threshold controls | ACTIVE; duplicate-hash and legacy-retention gaps evidenced |
| M2.3-04 | AU/NZ Course + Scholarship enrichment batches | PENDING control readiness |
| M2.3-05 | Layer 1/Layer 2 Admin UX maturity | PENDING runtime/source reconciliation |
| M2.3-06 | scale/economics KPI baseline | PENDING batch measurements |
| M2.3-07 | consolidated automated UAT | PENDING final implemented scope |

## 8. Security and Product boundaries

M2.3 must preserve:

- M1/M2.1/M2.2 accepted identity, fee, Evidence, Auth and Search semantics;
- leaked-password protection enabled for Pilot;
- no browser access to private operational Search/Vault/service-role surfaces;
- no broad Publication;
- no scraper-vendor logic inside Search/consumer integration;
- no Layer 3 interpretation disguised as Layer 2 deterministic extraction.

## 9. Blackout and Production boundaries

16–30 September remains a hard no-planned-delivery period.

Clean Production establishment remains M2.5. M2.3 must not create or promote a Production environment in place.

## 10. Current overall status

**M2.3 ACTIVE EARLY / RECONCILIATION AND IMPLEMENTATION UNDER CF-CHG-20260825-036.**